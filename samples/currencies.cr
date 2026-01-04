require "../src/monobank_api"

client = MonobankApi::Client.new("")

currencies = client.currencies

puts "Monobank Currencies:"
currencies.each do |currency|
  puts "#{MonobankApi::CurrencyData.code_alpha(currency.currency_code_a)} -> #{MonobankApi::CurrencyData.code_alpha(currency.currency_code_b)}: buy=#{currency.rate_buy}, sell=#{currency.rate_sell}, cross=#{currency.rate_cross} date=#{currency.date}"
end
