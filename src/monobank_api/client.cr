module MonobankApi
  class Client
    BASE_URL = "https://api.monobank.ua"

    Log = MonobankApi::Log.for(self)

    USER_AGENT = "MonobankApi-Crystal/#{MonobankApi::VERSION} (+https://github.com/mamantoha/monobank_api)"

    def initialize(@token : String, user_agent : String? = nil)
      @resource = Crest::Resource.new(
        BASE_URL,
        user_agent: user_agent || USER_AGENT,
        headers: {"X-Token" => @token},
        handle_errors: false,
        json: true
      )
    end

    # Отримати базовий перелік курсів валют monobank
    #
    # Інформація кешується та оновлюється не частіше 1 разу на 5 хвилин
    def currencies : Array(Currency)
      path = "/bank/currency"

      Log.debug { "GET #{BASE_URL}#{path}" }

      response = @resource[path].get

      log_response(path, response)

      if response.success?
        Array(Currency).from_json(response.body)
      else
        handle_exception(response)
      end
    end

    # Отримання інформації про клієнта та переліку його рахунків і банок
    #
    # Обмеження на використання функції: не частіше ніж 1 раз у 60 секунд
    def info : ClientInfo
      path = "/personal/client-info"

      Log.debug { "GET #{BASE_URL}#{path}" }

      response = @resource[path].get

      log_response(path, response)

      if response.success?
        ClientInfo.from_json(response.body)
      else
        handle_exception(response)
      end
    end

    # Отримання виписки за час від `from` до `to` часу
    #
    # Максимальний час за який можливо отримувати виписку: 31 доба + 1 година
    # Обмеження на використання функції: не частіше ніж 1 раз у 60 секунд
    #
    # Arguments:
    # - `account`: Ідентифікатор рахунку або банки з переліків або 0 - дефолтний рахунок
    # - `from`: Початок часу виписки
    # - `to`: Останній час виписки (необов'язковий, за замовчуванням `from + 31 діб + 1 година`)
    def statements(account : String, from : Time, to : Time? = nil) : Array(Statement)
      to ||= from + 31.days + 1.hour

      path = "/personal/statement/#{account}/#{from.to_unix}/#{to.to_unix}"

      Log.debug { "GET #{BASE_URL}#{path}" }

      response = @resource[path].get

      log_response(path, response)

      if response.success?
        Array(Statement).from_json(response.body)
      else
        handle_exception(response)
      end
    end

    # Встановлення URL користувача для отримання подій про зміну балансу
    #
    # Для підтвердження коректності наданої адреси, на неї надсилається GET-запит.
    # Сервер має відповісти строго HTTP статус-кодом 200.
    # Якщо валідацію пройдено, на задану адресу починають надсилатися POST запити з подіями.
    #
    # Події надсилаються у форматі: `{type:"StatementItem", data:{account:"...", statementItem:{#StatementItem}}}`
    #
    # Якщо сервіс не відповість протягом 5с, сервіс повторить спробу ще через 60 та 600 секунд.
    # Якщо на третю спробу відповідь отримана не буде, функція буде вимкнута.
    #
    # Arguments:
    # - `webhook_url`: URL для отримання POST запитів з подіями (або пустий рядок для видалення)
    def webhook=(webhook_url : String) : Bool
      path = "/personal/webhook"

      response = @resource[path].post(
        {webHookUrl: webhook_url}.to_json
      )

      log_url = webhook_url.empty? ? "<removed>" : webhook_url

      Log.debug { "POST #{BASE_URL}#{path} status=#{response.status_code} url=#{log_url}" }

      log_response(path, response)

      if response.success?
        true
      else
        handle_exception(response)
        false
      end
    end

    private def handle_exception(response)
      json = JSON.parse(response.body)

      error_message =
        json["errorDescription"]?.try(&.as_s) ||
          json["errText"]?.try(&.as_s) ||
          "Unknown error: `#{response.body}`"

      # Map HTTP status codes to specific exceptions
      case response.status_code
      when 400
        raise BadRequestError.new(error_message)
      when 401, 403
        raise InvalidTokenError.new(error_message)
      when 404
        raise NotFoundError.new(error_message)
      when 429
        raise RateLimitError.new(error_message)
      when 500, 502
        raise ServerError.new(error_message)
      when 503
        raise ServiceUnavailableError.new(error_message)
      else
        raise Error.new(error_message)
      end
    end

    private def log_response(path : String, response)
      body = response.body
      Log.debug { "Response #{path} status=#{response.status_code} body=#{body.inspect}" }
    rescue e
      Log.debug { "Response #{path} status=#{response.status_code} (failed to log body: #{e.message})" }
    end
  end
end
