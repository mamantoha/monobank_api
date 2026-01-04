module MonobankApi
  # Provides multilingual currency information by ISO 4217 numeric code
  #
  # Currency data is sourced from Our World in Data:
  # https://github.com/ourworldincode/currency
  # Raw data: https://raw.githubusercontent.com/ourworldincode/currency/main/currencies.json
  module CurrencyData
    # Currency data is compiled into the binary at compile time
    @@data : Hash(Int32, CurrencyInfo) = {} of Int32 => CurrencyInfo
    @@initialized = false

    # Load currency data from compiled JSON
    private def self.load_data
      return if @@initialized

      json_str = {{ read_file("#{__DIR__}/../../data/currencies.json") }}
      currencies = Currencies.from_json(json_str)

      currencies.each do |iso_code, currency_value|
        iso_num = currency_value.is_onum
        next if iso_num.nil?

        @@data[iso_num] = CurrencyInfo.new(
          iso_code: iso_code,
          iso_num: iso_num,
          name: currency_value.name,
          symbol: currency_value.symbol,
          symbol_native: currency_value.symbol_native
        )
      end

      @@initialized = true
    end

    # Повертає назву валюти за ISO 4217 кодом
    #
    # ```
    # CurrencyData.name(980) # => "Ukrainian Hryvnia"
    # CurrencyData.name(840) # => "United States Dollar"
    # ```
    def self.name(iso_num : Int32) : String?
      load_data
      @@data[iso_num]?.try(&.name)
    end

    # Повертає ISO 4217 трьохлітерний код валюти
    #
    # ```
    # MonobankApi::CurrencyData.code_alpha(980) # => "UAH"
    # MonobankApi::CurrencyData.code_alpha(840) # => "USD"
    # ```
    def self.code_alpha(iso_num : Int32) : String?
      load_data
      @@data[iso_num]?.try(&.iso_code)
    end

    # Повертає символ валюти
    #
    # ```
    # MonobankApi::CurrencyData.symbol(980) # => "₴"
    # MonobankApi::CurrencyData.symbol(840) # => "$"
    # ```
    def self.symbol(iso_num : Int32) : String?
      load_data
      @@data[iso_num]?.try(&.symbol)
    end

    # Повертає рідний символ валюти
    #
    # ```
    # MonobankApi::CurrencyData.symbol_native(980) # => "грн"
    # MonobankApi::CurrencyData.symbol_native(840) # => "$"
    # ```
    def self.symbol_native(iso_num : Int32) : String?
      load_data
      @@data[iso_num]?.try(&.symbol_native)
    end

    # Повертає ISO 4217 числовий код за трьохлітерним кодом
    #
    # ```
    # MonobankApi::CurrencyData.iso_num("UAH") # => 980
    # MonobankApi::CurrencyData.iso_num("USD") # => 840
    # ```
    def self.iso_num(code_alpha : String) : Int32?
      load_data
      code = code_alpha.upcase
      @@data.values.find { |info| info.iso_code.upcase == code }.try(&.iso_num)
    end

    private alias Currencies = Hash(String, CurrenciesValue)

    private class CurrenciesValue
      include JSON::Serializable

      property name : String
      property demonym : String

      @[JSON::Field(key: "majorSingle")]
      property major_single : String

      @[JSON::Field(key: "majorPlural")]
      property major_plural : String

      @[JSON::Field(key: "ISOnum")]
      property is_onum : Int32?

      property symbol : String

      @[JSON::Field(key: "symbolNative")]
      property symbol_native : String

      @[JSON::Field(key: "minorSingle")]
      property minor_single : String

      @[JSON::Field(key: "minorPlural")]
      property minor_plural : String

      @[JSON::Field(key: "ISOdigits")]
      property is_odigits : Int32

      property decimals : Int32

      @[JSON::Field(key: "numToBasic")]
      property num_to_basic : Int32?
    end

    private class CurrencyInfo
      property iso_code : String
      property iso_num : Int32
      property name : String
      property symbol : String
      property symbol_native : String

      def initialize(@iso_code, @iso_num, @name, @symbol, @symbol_native)
      end
    end
  end
end
