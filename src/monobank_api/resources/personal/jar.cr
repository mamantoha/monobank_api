module MonobankApi
  # Represents a client jar (savings goal).
  class Jar
    include JSON::Serializable

    # Ідентифікатор банки
    property id : String

    # Ідентифікатор для сервісу https://send.monobank.ua/{sendId}
    @[JSON::Field(key: "sendId")]
    property send_id : String

    # Назва банки
    property title : String

    # Опис банки
    property description : String

    # Код валюти банки відповідно ISO 4217
    @[JSON::Field(key: "currencyCode")]
    property currency_code : Int32

    # Баланс банки в мінімальних одиницях валюти (копійках, центах)
    property balance : Int32

    # Цільова сума для накопичення в банці в мінімальних одиницях валюти (копійках, центах)
    property goal : Int32
  end
end
