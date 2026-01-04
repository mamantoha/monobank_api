module MonobankApi
  # Represents client information and list of accounts and jars.
  #
  # Retrieved from `/personal/client-info` endpoint.
  # Rate limit: no more than 1 request per 60 seconds
  class ClientInfo
    include JSON::Serializable

    # Ідентифікатор клієнта (збігається з id для send.monobank.ua)
    @[JSON::Field(key: "clientId")]
    getter client_id : String

    # Ім'я клієнта
    getter name : String

    # URL для надсилання подій по зміні балансу рахунку
    @[JSON::Field(key: "webHookUrl")]
    getter web_hook_url : String

    # Перелік прав, які надає сервіс (1 літера на 1 permission)
    getter permissions : String

    # Перелік доступних рахунків
    getter accounts : Array(InfoAccount)

    # Перелік банок
    getter jars : Array(Jar)

    # Перелік клієнтів, які надали доступ до рахунків ФОП бухгалтеру
    @[JSON::Field(key: "managedClients")]
    getter managed_clients : Array(ManagedClient)?
  end
end
