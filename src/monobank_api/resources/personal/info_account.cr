module MonobankApi
  # Represents a client account.
  class InfoAccount
    include JSON::Serializable

    # Ідентифікатор рахунку
    property id : String

    # Ідентифікатор для сервісу https://send.monobank.ua/{sendId}
    @[JSON::Field(key: "sendId")]
    property send_id : String

    # Баланс рахунку в мінімальних одиницях валюти (копійках, центах)
    property balance : Int32

    # Кредитний ліміт
    @[JSON::Field(key: "creditLimit")]
    property credit_limit : Int32

    # Тип рахунку (black, white, platinum, iron, fop, yellow, eAid)
    @[JSON::Field(key: "type")]
    property account_type : String

    # Код валюти рахунку відповідно ISO 4217
    @[JSON::Field(key: "currencyCode")]
    property currency_code : Int32

    # Тип кешбеку який нараховується на рахунок (None, UAH, Miles)
    @[JSON::Field(key: "cashbackType")]
    property cashback_type : String

    # Перелік замаскованних номерів карт
    @[JSON::Field(key: "maskedPan")]
    property masked_pan : Array(String)

    # IBAN рахунку
    property iban : String
  end
end
