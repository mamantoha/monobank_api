module MonobankApi
  # Represents a transaction statement.
  #
  # Retrieved from `/personal/statement/{account}/{from}/{to}` endpoint.
  class Statement
    include JSON::Serializable

    # Унікальний id транзакції
    property id : String

    # Час транзакції в секундах в форматі Unix time
    @[JSON::Field(converter: Time::EpochConverter)]
    property time : Time

    # Опис транзакцій
    property description : String

    # Код типу транзакції (Merchant Category Code), відповідно ISO 18245
    property mcc : Int32

    # Оригінальний код типу транзакції (Merchant Category Code), відповідно ISO 18245
    @[JSON::Field(key: "originalMcc")]
    property original_mcc : Int32

    # Статус блокування суми
    property? hold : Bool

    # Сума у валюті рахунку в мінімальних одиницях валюти (копійках, центах)
    property amount : Int64

    # Сума у валюті транзакції в мінімальних одиницях валюти (копійках, центах)
    @[JSON::Field(key: "operationAmount")]
    property operation_amount : Int64

    # Код валюти рахунку відповідно ISO 4217
    @[JSON::Field(key: "currencyCode")]
    property currency_code : Int32

    # Розмір комісії в мінімальних одиницях валюти (копійках, центах)
    @[JSON::Field(key: "commissionRate")]
    property commission_rate : Int64

    # Розмір кешбеку в мінімальних одиницях валюти (копійках, центах)
    @[JSON::Field(key: "cashbackAmount")]
    property cashback_amount : Int64

    # Баланс рахунку в мінімальних одиницях валюти (копійках, центах)
    property balance : Int64

    # Коментар до переказу, уведений користувачем
    property comment : String?

    # Номер квитанції для check.gov.ua
    @[JSON::Field(key: "receiptId")]
    property receipt_id : String?

    # Номер квитанції ФОПа, приходить у випадку якщо це операція із зарахуванням коштів
    @[JSON::Field(key: "invoiceId")]
    property invoice_id : String?

    # ЄДРПОУ контрагента, присутній лише для елементів виписки рахунків ФОП
    @[JSON::Field(key: "counterEdrpou")]
    property counter_edrpou : String?

    # IBAN контрагента, присутній лише для елементів виписки рахунків ФОП
    @[JSON::Field(key: "counterIban")]
    property counter_iban : String?

    # Найменування контрагента
    @[JSON::Field(key: "counterName")]
    property counter_name : String?
  end
end
