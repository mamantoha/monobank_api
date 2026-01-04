require "./spec_helper"

# Specs for currency conversion utility
describe MonobankApi::CurrencyConverter do
  it "converts using live rates from cassette" do
    VCR.use_cassette("currencies") do
      converter = MonobankApi::CurrencyConverter.new

      # From cassette: USD/UAH rateBuy 42.1, EUR/UAH rateSell 50.2008
      converter.convert(100, "USD", "UAH").should be_close(4205.0, 0.0001)
      converter.convert(100, "USD", "EUR").should be_close(84.8896, 0.01)
      converter.convert(100, "EUR", "USD").should be_close(116.8, 0.01)
      converter.convert(50, "USD", "USD").should eq(50.0)
      expect_raises(ArgumentError) { converter.convert(10, "FOO", "USD") }
    end
  end
end
