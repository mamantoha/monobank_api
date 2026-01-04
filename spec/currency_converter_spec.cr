require "./spec_helper"

describe MonobankApi::CurrencyConverter do
  it "converts using live rates" do
    VCR.use_cassette("currencies") do
      converter = MonobankApi::CurrencyConverter.new

      converter.convert(100, "USD", "UAH").should be_close(4205.0, 0.0001)
      converter.convert(100, "USD", "EUR").should be_close(84.8896, 0.01)
      converter.convert(100, "EUR", "USD").should be_close(116.8, 0.01)
      converter.convert(100, "PLN", "JPY").should be_close(4366.42, 0.01)
      converter.convert(50, "USD", "USD").should eq(50.0)
      expect_raises(MonobankApi::UnknownCurrencyError) { converter.convert(10, "FOO", "USD") }
    end
  end

  it "converts using cached rates JSON" do
    VCR.use_cassette("currencies") do
      client = MonobankApi::Client.new("")
      rates_json = client.currencies.to_json

      converter = MonobankApi::CurrencyConverter.new(rates_json)

      converter.convert(100, "USD", "UAH").should be_close(4205.0, 0.0001)
      converter.convert(100, "USD", "EUR").should be_close(84.8896, 0.01)
    end
  end
end
