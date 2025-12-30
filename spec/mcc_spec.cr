require "./spec_helper"

describe MonobankApi::MCC do
  describe ".short_description" do
    it "returns Ukrainian short description by default" do
      result = MonobankApi::MCC.short_description(5411)
      result.should eq("Продукти")
    end

    it "returns English short description" do
      result = MonobankApi::MCC.short_description(5411, :en)
      result.should eq("Grocery")
    end

    it "returns Russian short description" do
      result = MonobankApi::MCC.short_description(5411, :ru)
      result.should eq("Продукты")
    end

    it "returns nil for non-existent MCC code" do
      result = MonobankApi::MCC.short_description(1)
      result.should be_nil
    end
  end

  describe ".full_description" do
    it "returns Ukrainian full description by default" do
      result = MonobankApi::MCC.full_description(5411)
      result.should eq("Продуктові магазини, супермаркети")
    end

    it "returns English full description" do
      result = MonobankApi::MCC.full_description(5411, :en)
      result.should eq("Grocery Stores, Supermarkets")
    end

    it "returns Russian full description" do
      result = MonobankApi::MCC.full_description(5411, :ru)
      result.should eq("Продуктовые магазины, супермаркеты")
    end

    it "returns nil for non-existent MCC code" do
      result = MonobankApi::MCC.full_description(1)
      result.should be_nil
    end
  end

  describe ".group_type" do
    it "returns group type code" do
      result = MonobankApi::MCC.group_type(5411)
      result.should eq("ROS")
    end

    it "returns nil for non-existent MCC code" do
      result = MonobankApi::MCC.group_type(1)
      result.should be_nil
    end
  end

  describe ".group_description" do
    it "returns Ukrainian group description by default" do
      result = MonobankApi::MCC.group_description(5411)
      result.should eq("Послуги роздрібної торгівлі")
    end

    it "returns English group description" do
      result = MonobankApi::MCC.group_description(5411, :en)
      result.should eq("Retail Outlet Services")
    end

    it "returns Russian group description" do
      result = MonobankApi::MCC.group_description(5411, :ru)
      result.should eq("Услуги розничной торговли")
    end

    it "returns nil for non-existent MCC code" do
      result = MonobankApi::MCC.group_description(1)
      result.should be_nil
    end
  end

  describe ".exists?" do
    it "returns true for existing MCC code" do
      result = MonobankApi::MCC.exists?(5411)
      result.should be_true
    end

    it "returns false for non-existent MCC code" do
      result = MonobankApi::MCC.exists?(1)
      result.should be_false
    end
  end

  describe "CODES" do
    it "loads MCC codes from JSON file" do
      MonobankApi::MCC::CODES.should_not be_empty
    end

    it "contains valid MCC code data" do
      code_data = MonobankApi::MCC::CODES[5411]?
      code_data.should_not be_nil

      if code_data
        code_data.mcc.should eq("5411")
        code_data.group.type.should eq("ROS")
        code_data.short_description.uk.should eq("Продукти")
        code_data.full_description.uk.should eq("Продуктові магазини, супермаркети")
      end
    end
  end
end
