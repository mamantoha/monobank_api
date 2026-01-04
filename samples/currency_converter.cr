require "../src/monobank_api"

# Sample: convert amount from one currency to another using Monobank public rates
# Usage: crystal samples/currency_converter.cr AMOUNT FROM TO
# Example: crystal samples/currency_converter.cr 100 USD EUR

if ARGV.size < 3
  STDERR.puts "Usage: crystal samples/currency_converter.cr AMOUNT FROM TO"
  exit 1
end

amount = ARGV[0].to_f
from_code = ARGV[1]
to_code = ARGV[2]

converter = MonobankApi::CurrencyConverter.new
result = converter.convert(amount, from_code, to_code)

puts "#{amount} #{from_code} = #{result.round(4)} #{to_code}"
