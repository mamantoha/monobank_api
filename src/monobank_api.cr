require "json"
require "crest"
require "./monobank_api/log"
require "./monobank_api/mcc"
require "./monobank_api/currency_data"
require "./monobank_api/currency_converter"
require "./monobank_api/client"
require "./monobank_api/exceptions"
require "./monobank_api/resources/**"

module MonobankApi
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}
end
