module MonobankApi
  # Represents currency exchange rates.
  #
  # Retrieved from `/bank/currency` endpoint.
  # Information is cached and updated no more than once per 5 minutes
  class Currency
    include JSON::Serializable

    # Код валюти рахунку відповідно ISO 4217
    @[JSON::Field(key: "currencyCodeA")]
    property currency_code_a : Int32

    # Код валюти рахунку відповідно ISO 4217
    @[JSON::Field(key: "currencyCodeB")]
    property currency_code_b : Int32

    # Час курсу в секундах в форматі Unix time
    @[JSON::Field(converter: Time::EpochConverter)]
    property date : Time

    # Курс продажу
    @[JSON::Field(key: "rateSell")]
    property rate_sell : Float64?

    # Курс покупки
    @[JSON::Field(key: "rateBuy")]
    property rate_buy : Float64?

    # Кросс-курс
    @[JSON::Field(key: "rateCross")]
    property rate_cross : Float64?
  end
end
