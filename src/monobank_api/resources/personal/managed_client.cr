module MonobankApi
  # Represents a managed client (for accountants).
  class ManagedClient
    include JSON::Serializable

    # Ідентифікатор клієнта
    @[JSON::Field(key: "clientId")]
    getter client_id : String

    # РНОКПП
    getter tin : Int32

    # Ім'я клієнта
    getter name : String

    # Перелік доступних рахунків ФОП
    getter accounts : Array(ManagedClientAccount)
  end
end
