require "../src/monobank_api"

token = ARGV[0]? || raise "Usage: statements.cr <token>"
client = MonobankApi::Client.new(token)

account_id = "Wr0FiCYJwhywOKCRhKtyIA"
from = 31.days.ago
to = Time.local
statements = client.statements(account_id, from, to)
statements = statements.first(40)

# p! statements

statements.each do |statement|
  amount = "%.2f" % (statement.amount / 100.0)
  balance = "%.2f" % (statement.balance / 100.0)
  puts "#{statement.time.to_local.to_s("%Y-%m-%d %H:%M:%S")} | #{statement.description} | #{amount} | #{balance} | #{statement.mcc}"
end
