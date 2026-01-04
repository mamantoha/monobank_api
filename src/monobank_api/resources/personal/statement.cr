module MonobankApi
  # Represents a transaction statement.
  #
  # Retrieved from `/personal/statement/{account}/{from}/{to}` endpoint.
  class Statement
    include JSON::Serializable

    # Унікальний id транзакції
    getter id : String

    # Час транзакції в секундах в форматі Unix time
    @[JSON::Field(converter: Time::EpochConverter)]
    getter time : Time

    # Опис транзакцій
    getter description : String

    # Код типу транзакції (Merchant Category Code), відповідно ISO 18245
    getter mcc : Int32

    # Оригінальний код типу транзакції (Merchant Category Code), відповідно ISO 18245
    @[JSON::Field(key: "originalMcc")]
    getter original_mcc : Int32

    # Статус блокування суми
    property? hold : Bool

    # Сума у валюті рахунку в мінімальних одиницях валюти (копійках, центах)
    getter amount : Int64

    # Сума у валюті транзакції в мінімальних одиницях валюти (копійках, центах)
    @[JSON::Field(key: "operationAmount")]
    getter operation_amount : Int64

    # Код валюти рахунку відповідно ISO 4217
    @[JSON::Field(key: "currencyCode")]
    getter currency_code : Int32

    # Розмір комісії в мінімальних одиницях валюти (копійках, центах)
    @[JSON::Field(key: "commissionRate")]
    getter commission_rate : Int64

    # Розмір кешбеку в мінімальних одиницях валюти (копійках, центах)
    @[JSON::Field(key: "cashbackAmount")]
    getter cashback_amount : Int64

    # Баланс рахунку в мінімальних одиницях валюти (копійках, центах)
    getter balance : Int64

    # Коментар до переказу, уведений користувачем
    getter comment : String?

    # Номер квитанції для check.gov.ua
    @[JSON::Field(key: "receiptId")]
    getter receipt_id : String?

    # Номер квитанції ФОПа, приходить у випадку якщо це операція із зарахуванням коштів
    @[JSON::Field(key: "invoiceId")]
    getter invoice_id : String?

    # ЄДРПОУ контрагента, присутній лише для елементів виписки рахунків ФОП
    @[JSON::Field(key: "counterEdrpou")]
    getter counter_edrpou : String?

    # IBAN контрагента, присутній лише для елементів виписки рахунків ФОП
    @[JSON::Field(key: "counterIban")]
    getter counter_iban : String?

    # Найменування контрагента
    @[JSON::Field(key: "counterName")]
    getter counter_name : String?

    # Повертає коротку назву категорії транзакції за MCC кодом
    #
    # ```
    # statement = MonobankApi::Client.new(token).statements(...).first
    # statement.mcc_short_description      # => "Продукти"
    # statement.mcc_short_description(:en) # => "Grocery"
    # statement.mcc_short_description(:ru) # => "Продукты"
    # ```
    def mcc_short_description(lang : Symbol = :uk) : String?
      MCC.short_description(mcc, lang)
    end

    # Повертає повну назву категорії транзакції за MCC кодом
    #
    # ```
    # statement = MonobankApi::Client.new(token).statements(...).first
    # statement.mcc_full_description      # => "Продуктові магазини, супермаркети"
    # statement.mcc_full_description(:en) # => "Grocery Stores, Supermarkets"
    # statement.mcc_full_description(:ru) # => "Продуктовые магазины, супермаркеты"
    # ```
    def mcc_full_description(lang : Symbol = :uk) : String?
      MCC.full_description(mcc, lang)
    end

    # Повертає тип групи категорії транзакції за MCC кодом
    #
    # ```
    # statement.mcc_group_type # => "ROS"
    # ```
    def mcc_group_type : String?
      MCC.group_type(mcc)
    end

    # Повертає назву групи категорії транзакції за MCC кодом
    #
    # ```
    # statement = MonobankApi::Client.new(token).statements(...).first
    # statement.mcc_group_description      # => "Послуги роздрібної торгівлі"
    # statement.mcc_group_description(:en) # => "Retail Outlet Services"
    # ```
    def mcc_group_description(lang : Symbol = :uk) : String?
      MCC.group_description(mcc, lang)
    end

    # Повертає назву валюти рахунку за ISO 4217 кодом
    #
    # ```
    # statement = MonobankApi::Client.new(token).statements(...).first
    # statement.currency_name # => "Ukrainian Hryvnia"
    # ```
    def currency_name : String?
      CurrencyData.name(currency_code)
    end

    # Повертає ISO 4217 трьохлітерний код валюти рахунку
    #
    # ```
    # statement = MonobankApi::Client.new(token).statements(...).first
    # statement.currency_code_alpha # => "UAH"
    # ```
    def currency_code_alpha : String?
      CurrencyData.code_alpha(currency_code)
    end

    # Повертає символ валюти рахунку
    #
    # ```
    # statement = MonobankApi::Client.new(token).statements(...).first
    # statement.currency_symbol # => "₴"
    # ```
    def currency_symbol : String?
      CurrencyData.symbol(currency_code)
    end
  end
end
