require "file_utils"
require "../src/monobank_api"

# Sample: convert amount from one currency to another using Monobank public rates
# Usage: crystal samples/currency_converter.cr AMOUNT FROM TO
# Example: crystal samples/currency_converter.cr 100 USD EUR

if ARGV.size < 3
  STDERR.puts "Usage: crystal samples/currency_converter.cr AMOUNT FROM TO"
  exit 1
end

amount = ARGV[0].to_f
from_code = ARGV[1].upcase
to_code = ARGV[2].upcase

FRESHNESS = 5.minutes

def default_cache_path
  tmpdir = ENV["TMPDIR"]? || "/tmp"
  File.join(tmpdir, "monobank_currency_cache.json")
end

CACHE_PATH = ENV["CURRENCY_CACHE_PATH"]? || default_cache_path

def cache_fresh?(path : String) : Bool
  return false unless File.exists?(path)

  info = File.info(path)

  return false if info.size == 0

  Time.utc - info.modification_time < FRESHNESS
rescue
  false
end

def load_converter_from_cache(path : String) : MonobankApi::CurrencyConverter
  json = File.read(path)

  MonobankApi::CurrencyConverter.new(json)
end

def fetch_and_cache_converter(path : String) : MonobankApi::CurrencyConverter
  client = MonobankApi::Client.new("")
  rates = client.currencies

  FileUtils.mkdir_p(File.dirname(path))
  File.write(path, rates.to_json)

  MonobankApi::CurrencyConverter.new(rates)
end

converter = if cache_fresh?(CACHE_PATH)
              begin
                load_converter_from_cache(CACHE_PATH)
              rescue e
                STDERR.puts "Cache invalid, refetching: #{e.message}"
                fetch_and_cache_converter(CACHE_PATH)
              end
            else
              fetch_and_cache_converter(CACHE_PATH)
            end

result = converter.convert(amount, from_code, to_code)

puts "#{amount} #{from_code} = #{result.round(4)} #{to_code}"
