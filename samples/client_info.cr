require "../src/monobank_api"

token = ARGV[0]? || raise "Usage: client_info.cr <token>"
client = MonobankApi::Client.new(token)

level = Log::Severity.parse?(ENV["LOG_LEVEL"]? || "info") || Log::Severity::Info
Log.setup(level)

info = client.info

puts "═" * 80
puts "CLIENT INFO"
puts "═" * 80

if info.name
  puts "\n👤 Client: #{info.name}"
end

puts "\n📊 ACCOUNTS:"
puts "─" * 80

info.accounts.each do |account|
  currency_symbol = MonobankApi::CurrencyData.symbol(account.currency_code) || "?"
  balance = (account.balance / 100.0).to_s + " #{currency_symbol}"

  puts "\n  ID: #{account.id}"
  puts "  Type: #{account.account_type}"
  puts "  Balance: #{balance}"
  puts "  Currency: #{MonobankApi::CurrencyData.code_alpha(account.currency_code)} (#{MonobankApi::CurrencyData.name(account.currency_code)})"

  if account.credit_limit > 0
    credit_limit = (account.credit_limit / 100.0).to_s + " #{currency_symbol}"
    puts "  Credit Limit: #{credit_limit}"
  end

  puts "  IBAN: #{account.iban}"
end

if info.jars.any?
  puts "\n\n🏺 JARS:"
  puts "─" * 80

  info.jars.each do |jar|
    currency_symbol = MonobankApi::CurrencyData.symbol(jar.currency_code) || "?"
    balance = (jar.balance / 100.0).to_s + " #{currency_symbol}"

    puts "\n  Name: #{jar.title}"
    puts "  ID: #{jar.id}"
    puts "  Balance: #{balance}"
    puts "  Currency: #{MonobankApi::CurrencyData.code_alpha(jar.currency_code)}"

    if jar.goal > 0
      goal = (jar.goal / 100.0).to_s + " #{currency_symbol}"
      puts "  Goal: #{goal}"
    end
  end
end

puts "\n" + "═" * 80
