require "./spec_helper"

describe MonobankApi::CurrencyData do
  describe ".name" do
    it "returns Ukrainian Hryvnia name for ISO code 980" do
      result = MonobankApi::CurrencyData.name(980)
      result.should eq("Ukrainian Hryvnia")
    end

    it "returns US Dollar name for ISO code 840" do
      result = MonobankApi::CurrencyData.name(840)
      result.should eq("United States Dollar")
    end

    it "returns Euro name for ISO code 978" do
      result = MonobankApi::CurrencyData.name(978)
      result.should eq("Euro")
    end

    it "returns nil for non-existent ISO code" do
      result = MonobankApi::CurrencyData.name(999)
      result.should be_nil
    end

    it "returns nil for ISO code 0" do
      result = MonobankApi::CurrencyData.name(0)
      result.should be_nil
    end
  end

  describe ".code_alpha" do
    it "returns UAH for ISO code 980" do
      result = MonobankApi::CurrencyData.code_alpha(980)
      result.should eq("UAH")
    end

    it "returns USD for ISO code 840" do
      result = MonobankApi::CurrencyData.code_alpha(840)
      result.should eq("USD")
    end

    it "returns EUR for ISO code 978" do
      result = MonobankApi::CurrencyData.code_alpha(978)
      result.should eq("EUR")
    end

    it "returns GBP for ISO code 826" do
      result = MonobankApi::CurrencyData.code_alpha(826)
      result.should eq("GBP")
    end

    it "returns nil for non-existent ISO code" do
      result = MonobankApi::CurrencyData.code_alpha(999)
      result.should be_nil
    end
  end

  describe ".symbol" do
    it "returns ₴ for Ukrainian Hryvnia (980)" do
      result = MonobankApi::CurrencyData.symbol(980)
      result.should eq("₴")
    end

    it "returns $ for US Dollar (840)" do
      result = MonobankApi::CurrencyData.symbol(840)
      result.should eq("$")
    end

    it "returns € for Euro (978)" do
      result = MonobankApi::CurrencyData.symbol(978)
      result.should eq("€")
    end

    it "returns £ for British Pound (826)" do
      result = MonobankApi::CurrencyData.symbol(826)
      result.should eq("£")
    end

    it "returns nil for non-existent ISO code" do
      result = MonobankApi::CurrencyData.symbol(999)
      result.should be_nil
    end
  end

  describe ".symbol_native" do
    it "returns грн for Ukrainian Hryvnia (980)" do
      result = MonobankApi::CurrencyData.symbol_native(980)
      result.should eq("грн")
    end

    it "returns $ for US Dollar (840)" do
      result = MonobankApi::CurrencyData.symbol_native(840)
      result.should eq("$")
    end

    it "returns € for Euro (978)" do
      result = MonobankApi::CurrencyData.symbol_native(978)
      result.should eq("€")
    end

    it "returns ¥元 for Chinese Yuan (156)" do
      result = MonobankApi::CurrencyData.symbol_native(156)
      result.should eq("¥元")
    end

    it "returns nil for non-existent ISO code" do
      result = MonobankApi::CurrencyData.symbol_native(999)
      result.should be_nil
    end
  end
end
