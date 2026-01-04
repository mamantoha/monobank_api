module MonobankApi
  # Represents a client jar (savings goal).
  class Jar
    include JSON::Serializable

    # Ідентифікатор банки
    getter id : String

    # Ідентифікатор для сервісу https://send.monobank.ua/{sendId}
    @[JSON::Field(key: "sendId")]
    getter send_id : String

    # Назва банки
    getter title : String

    # Опис банки
    getter description : String

    # Код валюти банки відповідно ISO 4217
    @[JSON::Field(key: "currencyCode")]
    getter currency_code : Int32

    # Баланс банки в мінімальних одиницях валюти (копійках, центах)
    getter balance : Int32

    # Цільова сума для накопичення в банці в мінімальних одиницях валюти (копійках, центах)
    getter goal : Int32
  end
end
