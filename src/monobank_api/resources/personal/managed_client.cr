module MonobankApi
  # Represents a managed client (for accountants).
  class ManagedClient
    include JSON::Serializable

    # Ідентифікатор клієнта
    @[JSON::Field(key: "clientId")]
    property client_id : String

    # РНОКПП
    property tin : Int32

    # Ім'я клієнта
    property name : String

    # Перелік доступних рахунків ФОП
    property accounts : Array(ManagedClientAccount)
  end
end
