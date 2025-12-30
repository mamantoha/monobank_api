# monobank_api

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

# Get MCC descriptions for transactions
statements.each do |statement|
  puts statement.mcc_short_description # => "Продукти"
  puts statement.mcc_full_description  # => "Продуктові магазини, супермаркети"
  puts statement.mcc_group_type        # => "ROS"
  puts statement.mcc_group_description # => "Послуги роздрібної торгівлі"

  # Multi-language support
  puts statement.mcc_short_description(:en) # => "Grocery"
  puts statement.mcc_full_description(:ru)  # => "Продуктовые магазины, супермаркеты"
end

# Use MCC module directly
MonobankApi::MCC.short_description(5411)      # => "Продукти"
MonobankApi::MCC.full_description(5411, :en)  # => "Grocery Stores, Supermarkets"
MonobankApi::MCC.group_type(5411)             # => "ROS"
MonobankApi::MCC.group_description(5411, :ru) # => "Услуги розничной торговли"
```

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
