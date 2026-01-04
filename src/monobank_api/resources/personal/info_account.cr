module MonobankApi
  # Represents a client account.
  class InfoAccount
    include JSON::Serializable

    # Ідентифікатор рахунку
    getter id : String

    # Ідентифікатор для сервісу https://send.monobank.ua/{sendId}
    @[JSON::Field(key: "sendId")]
    getter send_id : String

    # Баланс рахунку в мінімальних одиницях валюти (копійках, центах)
    getter balance : Int32

    # Кредитний ліміт
    @[JSON::Field(key: "creditLimit")]
    getter credit_limit : Int32

    # Тип рахунку (black, white, platinum, iron, fop, yellow, eAid)
    @[JSON::Field(key: "type")]
    getter account_type : String

    # Код валюти рахунку відповідно ISO 4217
    @[JSON::Field(key: "currencyCode")]
    getter currency_code : Int32

    # Тип кешбеку який нараховується на рахунок (None, UAH, Miles)
    @[JSON::Field(key: "cashbackType")]
    getter cashback_type : String

    # Перелік замаскованних номерів карт
    @[JSON::Field(key: "maskedPan")]
    getter masked_pan : Array(String)

    # IBAN рахунку
    getter iban : String
  end
end
