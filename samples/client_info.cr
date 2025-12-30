require "../src/monobank_api"

token = ARGV[0]? || raise "Usage: client_info.cr <token>"
client = MonobankApi::Client.new(token)

p! client.info
