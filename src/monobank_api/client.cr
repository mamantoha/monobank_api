module MonobankApi
  class Client
    def initialize(@token : String)
      @resource = Crest::Resource.new(
        "https://api.monobank.ua",
        headers: {"X-Token" => @token},
        handle_errors: false,
        json: true
      )
    end

    # Отримати базовий перелік курсів валют monobank
    #
    # Інформація кешується та оновлюється не частіше 1 разу на 5 хвилин
    def currencies : Array(Currency)
      response = @resource["/bank/currency"].get

      if response.success?
        Array(Currency).from_json(response.body)
      else
        handle_exception(response.body)
      end
    end

    # Отримання інформації про клієнта та переліку його рахунків і банок
    #
    # Обмеження на використання функції: не частіше ніж 1 раз у 60 секунд
    def info : ClientInfo
      response = @resource["/personal/client-info"].get

      if response.success?
        ClientInfo.from_json(response.body)
      else
        handle_exception(response.body)
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
    # - `to`: Останній час виписки (якщо відсутній, буде використовуватись поточний час)
    def statements(account : String, from : Time, to : Time? = nil) : Array(Statement)
      path = "/personal/statement/#{account}/#{from.to_unix}/#{to.to_unix}"

      response = @resource[path].get

      if response.success?
        Array(Statement).from_json(response.body)
      else
        handle_exception(response.body)
      end
    end

    private def handle_exception(response_body)
      json = JSON.parse(response_body)

      if error_description = json["errorDescription"]?
        raise Error.new(error_description.as_s)
      else
        raise Error.new("Unknown error: `#{response_body}`")
      end
    end
  end
end
