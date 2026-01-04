# monobank_api

[![Crystal CI](https://github.com/mamantoha/monobank_api/actions/workflows/crystal.yml/badge.svg)](https://github.com/mamantoha/monobank_api/actions/workflows/crystal.yml)
[![GitHub release](https://img.shields.io/github/release/mamantoha/monobank_api.svg)](https://github.com/mamantoha/monobank_api/releases)
[![License](https://img.shields.io/github/license/mamantoha/monobank_api.svg)](https://github.com/mamantoha/monobank_api/blob/main/LICENSE)

Crystal library for [Monobank](https://monobank.ua) open API (v250818).

## About

API для отримання інформації про виписки та стан особистого рахунку та рахунків ФОП. Для надання доступу потрібно пройти авторизацію у особистому кабінеті <https://api.monobank.ua/> та отримати токен для персонального використання.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     monobank_api:
       github: mamantoha/monobank_api
   ```

2. Run `shards install`

## Usage

```crystal
require "monobank_api"

token = "YOUR_TOKEN_HERE"
client = MonobankApi::Client.new(token)

# Get currency rates
currencies = client.currencies

# Get client info with accounts and jars
info = client.info

# Get account statements
account_id = "YOUR_ACCOUNT_ID"
from = 7.days.ago
to = Time.local

statements = client.statements(account_id, from, to)

# Get MCC descriptions and currency info for transactions
statements.each do |statement|
  puts statement.time                  # => 2025-12-29 09:20:00 UTC
  puts statement.description           # => "Spotify"
  puts statement.amount                # => -21138
  puts statement.balance               # => 100000
  puts statement.mcc_short_description # => "Цифрові товари"
  puts statement.mcc_full_description  # => "Цифрові товари: книги, фільми, музика"
  puts statement.mcc_group_type        # => "MS"
  puts statement.mcc_group_description # => "Інші магазини"

  # Multi-language support for MCC
  puts statement.mcc_short_description(:en) # => "Digital Goods"
  puts statement.mcc_full_description(:ru)  # => "Цифровые товары: книги, фильмы, музыка"

  # Currency information
  puts statement.currency_code_alpha # => "UAH"
  puts statement.currency_name       # => "Ukrainian Hryvnia"
  puts statement.currency_symbol     # => "₴"
end

# Use MCC module directly
MonobankApi::MCC.short_description(5411)     # => "Продукти"
MonobankApi::MCC.full_description(5411, :en) # => "Grocery Stores, Supermarkets"
MonobankApi::MCC.group_type(5411)            # => "ROS"

# Use Currency module directly
MonobankApi::CurrencyData.name(980)       # => "Ukrainian Hryvnia"
MonobankApi::CurrencyData.code_alpha(980) # => "UAH"
MonobankApi::CurrencyData.symbol(980)     # => "₴"

# Convert currencies (amount, from, to)
converter = MonobankApi::CurrencyConverter.new
converter.convert(100, "USD", "EUR") # => 83.8632
```

## Currency Information

Бібліотека включає в себе дані про валюти за ISO 4217 кодами з підтримкою багатомовних назв та символів. Дані взято з репозиторію [Our World in Data - Currency](https://github.com/ourworldindata/currency).

### Можливості Currency

- **Назва валюти** - `CurrencyData.name(iso_num)` (наприклад, "Ukrainian Hryvnia")
- **ISO 4217 Код** - `CurrencyData.code_alpha(iso_num)` (наприклад, "UAH")
- **Символ** - `CurrencyData.symbol(iso_num)` (наприклад, "₴")
- **Рідний символ** - `CurrencyData.symbol_native(iso_num)` (наприклад, "грн")

## MCC Codes

Бібліотека включає в себе описи кодів MCC (Merchant Category Code) з підтримкою мультимовності (українська, англійська, російська) та групування категорій. Дані взято з репозиторію [Oleksios/Merchant-Category-Codes](https://github.com/Oleksios/Merchant-Category-Codes).

### Можливості MCC

- **Коротка назва** - `short_description(mcc, :uk/:en/:ru)`
- **Повна назва** - `full_description(mcc, :uk/:en/:ru)`
- **Тип групи** - `group_type(mcc)` (повертає код групи, наприклад "ROS", "HR", "AL")
- **Назва групи** - `group_description(mcc, :uk/:en/:ru)`

За замовчуванням використовується українська мова.

## Documentation

Документація Monobank API доступна на <https://api.monobank.ua/docs/index.html>

## Contributing

1. Fork it (<https://github.com/mamantoha/monobank_api/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Anton Maminov](https://github.com/mamantoha) - creator and maintainer
