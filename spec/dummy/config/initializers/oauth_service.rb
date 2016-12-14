OauthService.setup do |config|

  config.add_provider(:google, OauthService::Providers::Google) do |provider_config|
    provider_config.auth_url = ENV["GOOGLE_AUTH_URL"]
    provider_config.client_id = ENV["GOOGLE_CLIENT_ID"]
    provider_config.client_secret = ENV["GOOGLE_CLIENT_SECRET"]
    provider_config.info_url = ENV["GOOGLE_INFO_URL"]
    provider_config.scopes = ENV["GOOGLE_SCOPES"]
    provider_config.token_url = ENV["GOOGLE_TOKEN_URL"]
  end

  config.add_provider(:yandex, OauthService::Providers::Yandex) do |provider_config|
    provider_config.auth_url = ENV["YANDEX_AUTH_URL"]
    provider_config.client_id = ENV["YANDEX_CLIENT_ID"]
    provider_config.client_secret = ENV["YANDEX_CLIENT_SECRET"]
    provider_config.info_url = ENV["YANDEX_INFO_URL"]
    provider_config.scopes = ENV["YANDEX_SCOPES"]
    provider_config.token_url = ENV["YANDEX_TOKEN_URL"]
  end
end
