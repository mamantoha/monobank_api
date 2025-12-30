module MonobankApi
  # Represents client information and list of accounts and jars.
  #
  # Retrieved from `/personal/client-info` endpoint.
  # Rate limit: no more than 1 request per 60 seconds
  class ClientInfo
    include JSON::Serializable

    # Ідентифікатор клієнта (збігається з id для send.monobank.ua)
    @[JSON::Field(key: "clientId")]
    property client_id : String

    # Ім'я клієнта
    property name : String

    # URL для надсилання подій по зміні балансу рахунку
    @[JSON::Field(key: "webHookUrl")]
    property web_hook_url : String

    # Перелік прав, які надає сервіс (1 літера на 1 permission)
    property permissions : String

    # Перелік доступних рахунків
    property accounts : Array(InfoAccount)

    # Перелік банок
    property jars : Array(Jar)

    # Перелік клієнтів, які надали доступ до рахунків ФОП бухгалтеру
    @[JSON::Field(key: "managedClients")]
    property managed_clients : Array(ManagedClient)?
  end
end
