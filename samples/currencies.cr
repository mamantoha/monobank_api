require "../src/monobank_api"

level = Log::Severity.parse?(ENV["LOG_LEVEL"]? || "info") || Log::Severity::Info
Log.setup(level)

client = MonobankApi::Client.new("")

currencies = client.currencies

puts "Monobank Currencies:"
currencies.each do |currency|
  puts "#{MonobankApi::CurrencyData.code_alpha(currency.currency_code_a)} (#{MonobankApi::CurrencyData.name(currency.currency_code_a)}) -> #{MonobankApi::CurrencyData.code_alpha(currency.currency_code_b)}: buy=#{currency.rate_buy}, sell=#{currency.rate_sell}, cross=#{currency.rate_cross} date=#{currency.date}"
end
