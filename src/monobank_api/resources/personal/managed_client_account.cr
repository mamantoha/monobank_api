module MonobankApi
  # Represents a managed account (for accountants).
  class ManagedClientAccount
    include JSON::Serializable

    # Ідентифікатор рахунку
    getter id : String

    # Баланс рахунку в мінімальних одиницях валюти (копійках, центах)
    getter balance : Int32

    # Кредитний ліміт
    @[JSON::Field(key: "creditLimit")]
    getter credit_limit : Int32

    # Тип рахунку (fop)
    @[JSON::Field(key: "type")]
    getter account_type : String

    # Код валюти рахунку відповідно ISO 4217
    @[JSON::Field(key: "currencyCode")]
    getter currency_code : Int32

    # IBAN рахунку
    getter iban : String
  end
end
