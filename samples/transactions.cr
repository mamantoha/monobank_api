require "../src/monobank_api"

def format_table(
  data : Array(Hash(String, _)),
  align_right_keys : Set(String) = Set(String).new,
  separator = " | ",
) : String
  return "" if data.empty?

  keys = data.first.keys

  width_by_key = keys.to_h do |key|
    {key, data.max_of(&.[key]?.to_s.size)}
  end

  data.join('\n') do |row|
    keys.join(separator) do |key|
      value = row[key]?.to_s || ""
      width = width_by_key[key]

      align_right_keys.includes?(key) ? value.rjust(width) : value.ljust(width)
    end
  end
end

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
    "time"        => statement.time,
    "description" => statement.description,
    "amount"      => amount,
    "balance"     => balance,
    "mcc"         => statement.mcc,
  }
end

puts format_table(data, Set{"amount", "balance"})
