module MonobankApi
  # Represents currency exchange rates.
  #
  # Retrieved from `/bank/currency` endpoint.
  # Information is cached and updated no more than once per 5 minutes
  class Currency
    include JSON::Serializable

    # Код валюти рахунку відповідно ISO 4217
    @[JSON::Field(key: "currencyCodeA")]
    getter currency_code_a : Int32

    # Код валюти рахунку відповідно ISO 4217
    @[JSON::Field(key: "currencyCodeB")]
    getter currency_code_b : Int32

    # Час курсу в секундах в форматі Unix time
    @[JSON::Field(converter: Time::EpochConverter)]
    getter date : Time

    # Курс продажу
    @[JSON::Field(key: "rateSell")]
    getter rate_sell : Float64?

    # Курс покупки
    @[JSON::Field(key: "rateBuy")]
    getter rate_buy : Float64?

    # Кросс-курс
    @[JSON::Field(key: "rateCross")]
    getter rate_cross : Float64?
  end
end
