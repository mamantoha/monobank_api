module MonobankApi
  # MCC (Merchant Category Code) utilities
  #
  # Provides lookup for merchant category codes with multi-language support
  module MCC
    # Multi-language description
    record Description,
      uk : String,
      en : String,
      ru : String do
      include JSON::Serializable
    end

    # MCC group information
    record Group,
      type : String,
      description : Description do
      include JSON::Serializable
    end

    # MCC code data structure
    record CodeData,
      mcc : String,
      group : Group,
      full_description : Description,
      short_description : Description do
      include JSON::Serializable

      @[JSON::Field(key: "fullDescription")]
      property full_description : Description

      @[JSON::Field(key: "shortDescription")]
      property short_description : Description
    end

    # Loads MCC codes from embedded JSON file
    private def self.load_codes : Hash(Int32, CodeData)
      codes = {} of Int32 => CodeData

      json_data = {{ read_file("#{__DIR__}/../../data/mcc_codes.json") }}
      Array(CodeData).from_json(json_data).each do |code_data|
        codes[code_data.mcc.to_i] = code_data
      end

      codes
    rescue
      {} of Int32 => CodeData
    end

    # Cached MCC codes
    CODES = load_codes

    # Get short description for MCC code
    #
    # ```
    # MonobankApi::MCC.short_description(5411)      # => "Продукти"
    # MonobankApi::MCC.short_description(5411, :en) # => "Grocery"
    # MonobankApi::MCC.short_description(5411, :ru) # => "Продукты"
    # ```
    def self.short_description(mcc : Int32, lang : Symbol = :uk) : String?
      code_data = CODES[mcc]?
      return unless code_data

      case lang
      when :uk then code_data.short_description.uk
      when :en then code_data.short_description.en
      when :ru then code_data.short_description.ru
      else          code_data.short_description.uk
      end
    end

    # Get full description for MCC code
    #
    # ```
    # MonobankApi::MCC.full_description(5411)      # => "Продуктові магазини, супермаркети"
    # MonobankApi::MCC.full_description(5411, :en) # => "Grocery Stores, Supermarkets"
    # MonobankApi::MCC.full_description(5411, :ru) # => "Продуктовые магазины, супермаркеты"
    # ```
    def self.full_description(mcc : Int32, lang : Symbol = :uk) : String?
      code_data = CODES[mcc]?
      return unless code_data

      case lang
      when :uk then code_data.full_description.uk
      when :en then code_data.full_description.en
      when :ru then code_data.full_description.ru
      else          code_data.full_description.uk
      end
    end

    # Get group type for MCC code
    #
    # ```
    # MonobankApi::MCC.group_type(5411) # => "ROS"
    # ```
    def self.group_type(mcc : Int32) : String?
      CODES[mcc]?.try(&.group.type)
    end

    # Get group description for MCC code
    #
    # ```
    # MonobankApi::MCC.group_description(5411)      # => "Послуги роздрібної торгівлі"
    # MonobankApi::MCC.group_description(5411, :en) # => "Retail Outlet Services"
    # ```
    def self.group_description(mcc : Int32, lang : Symbol = :uk) : String?
      code_data = CODES[mcc]?
      return unless code_data

      case lang
      when :uk then code_data.group.description.uk
      when :en then code_data.group.description.en
      when :ru then code_data.group.description.ru
      else          code_data.group.description.uk
      end
    end

    # Check if MCC code exists
    def self.exists?(mcc : Int32) : Bool
      CODES.has_key?(mcc)
    end
  end
end
