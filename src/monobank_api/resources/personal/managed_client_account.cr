module MonobankApi
  # Represents a managed account (for accountants).
  class ManagedClientAccount
    include JSON::Serializable

    # Ідентифікатор рахунку
    property id : String

    # Баланс рахунку в мінімальних одиницях валюти (копійках, центах)
    property balance : Int32

    # Кредитний ліміт
    @[JSON::Field(key: "creditLimit")]
    property credit_limit : Int32

    # Тип рахунку (fop)
    @[JSON::Field(key: "type")]
    property account_type : String

    # Код валюти рахунку відповідно ISO 4217
    @[JSON::Field(key: "currencyCode")]
    property currency_code : Int32

    # IBAN рахунку
    property iban : String
  end
end
