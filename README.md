# monobank_api

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
```

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
