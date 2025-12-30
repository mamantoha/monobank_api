require "../src/monobank_api"

token = ARGV[0]? || raise "Usage: statements.cr <token>"
client = MonobankApi::Client.new(token)

account_id = "Wr0FiCYJwhywOKCRhKtyIA"
from = 31.days.ago
to = Time.local
statements = client.statements(account_id, from, to)
statements = statements.first(40)

# p! statements

data = statements.map do |statement|
  amount = (statement.amount / 100.0).format(decimal_places: 2)
  balance = (statement.balance / 100.0).format(decimal_places: 2)

  {
    time:        statement.time,
    description: statement.description,
    amount:      amount,
    balance:     balance,
    mcc:         statement.mcc,
  }
end

keys = [:time, :description, :amount, :balance, :mcc]

widths = keys.map do |k|
  data.map { |row| row[k].to_s.size }.max
end

data.each do |row|
  cells = keys.map { |k| row[k].to_s }

  line = cells.each_with_index.map do |cell, i|
    key = keys[i]

    if key == :amount || key == :balance || key == :mcc
      cell.rjust(widths[i])
    else
      cell.ljust(widths[i])
    end
  end.join(" | ")

  puts line
end
