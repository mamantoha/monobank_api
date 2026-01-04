module MonobankApi
  # Converts amounts between currencies using Monobank exchange rates
  class CurrencyConverter
    UAH_ISO = 980

    def initialize
      @rates = Client.new("").currencies
    end

    # Convert amount from one currency to another using ISO 4217 alpha codes
    #
    # ```
    # converter = MonobankApi::CurrencyConverter.new
    # converter.convert(100, "USD", "EUR")
    # ```
    def convert(amount : Number, from_code : String, to_code : String) : Float64
      from_iso = CurrencyData.iso_num(from_code) || raise ArgumentError.new("Unknown currency #{from_code}")
      to_iso = CurrencyData.iso_num(to_code) || raise ArgumentError.new("Unknown currency #{to_code}")
      convert_iso(amount.to_f, from_iso, to_iso)
    end

    private def convert_iso(amount : Float64, from_iso : Int32, to_iso : Int32, depth = 0) : Float64
      raise "Conversion depth exceeded" if depth > 4
      return amount if from_iso == to_iso

      if direct = find_rate(from_iso, to_iso)
        if rate = forward_rate(direct)
          return amount * rate
        end
      end

      if inverse = find_rate(to_iso, from_iso)
        if rate = inverse_rate(inverse)
          return amount / rate
        end
      end

      # Fallback: convert via UAH if available
      if from_iso != UAH_ISO && to_iso != UAH_ISO
        to_uah = convert_iso(amount, from_iso, UAH_ISO, depth + 1)
        return convert_iso(to_uah, UAH_ISO, to_iso, depth + 1)
      end

      raise "No conversion rate for #{from_iso} -> #{to_iso}"
    end

    private def find_rate(code_a : Int32, code_b : Int32) : Currency?
      @rates.find { |rate| rate.currency_code_a == code_a && rate.currency_code_b == code_b }
    end

    private def forward_rate(rate : Currency) : Float64?
      rate.rate_cross || rate.rate_buy || rate.rate_sell
    end

    private def inverse_rate(rate : Currency) : Float64?
      rate.rate_cross || rate.rate_sell || rate.rate_buy
    end
  end
end
