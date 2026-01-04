require "./spec_helper"

TOKEN = "u3AulkpZFI1lIuGsik6vuPsVWqN7GoWs6o_MO2sdf301"

describe MonobankApi::Client do
  describe "#currencies" do
    it "returns array of currencies" do
      VCR.use_cassette("currencies") do
        client = MonobankApi::Client.new(TOKEN)
        currencies = client.currencies

        currencies.should be_a(Array(MonobankApi::Currency))
        currencies.size.should be > 0

        # Check first currency structure
        first = currencies.first
        first.currency_code_a.should be_a(Int32)
        first.currency_code_b.should be_a(Int32)
        first.date.should be_a(Time)
      end
    end
  end

  describe "#info" do
    it "returns client info with accounts and jars" do
      VCR.use_cassette("client_info") do
        client = MonobankApi::Client.new(TOKEN)
        info = client.info

        info.should be_a(MonobankApi::ClientInfo)
        info.client_id.should be_a(String)
        info.name.should eq("<NAME>")
        info.accounts.should be_a(Array(MonobankApi::InfoAccount))
        info.jars.should be_a(Array(MonobankApi::Jar))
      end
    end
  end

  describe "#statements" do
    it "returns array of statements for account" do
      VCR.use_cassette("statements") do
        client = MonobankApi::Client.new(TOKEN)
        account_id = "0"
        from = Time.utc(2025, 12, 1, 0, 0, 0)
        to = Time.utc(2025, 12, 31, 0, 0, 0)

        statements = client.statements(account_id, from, to)

        statements.should be_a(Array(MonobankApi::Statement))

        if statement = statements.first
          statement.description.should eq("Test purchase")
          statement.amount.should eq(-2000)
          statement.time.should eq(Time.utc(2025, 12, 29, 9, 20, 0))
          statement.mcc_short_description.should eq("Фаст-фуд")
          statement.mcc_full_description.should eq("Ресторани швидкого харчування")
          statement.mcc_group_type.should eq("MS")
          statement.currency_name.should eq("Ukrainian Hryvnia")
          statement.currency_code_alpha.should eq("UAH")
          statement.currency_symbol.should eq("₴")
        end
      end
    end
  end

  describe "error handling" do
    it "raises InvalidTokenError on invalid token" do
      VCR.use_cassette("invalid_token") do
        client = MonobankApi::Client.new("invalid_token")

        expect_raises(MonobankApi::InvalidTokenError) do
          client.info
        end
      end
    end
  end
end
