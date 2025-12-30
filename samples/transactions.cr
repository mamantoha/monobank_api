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
    :time        => statement.time,
    :description => statement.description,
    :amount      => amount,
    :balance     => balance,
    :mcc         => statement.mcc,
  }
end

keys = data.first.keys

width_by_key = keys.to_h do |k|
  {k, data.max_of(&.[k].to_s.size)}
end

numeric_keys = Set{:amount, :balance, :mcc}

data.each do |row|
  line = keys.join(" | ") do |key|
    value = row[key].to_s
    width = width_by_key[key]

    numeric_keys.includes?(key) ? value.rjust(width) : value.ljust(width)
  end

  puts line
end
