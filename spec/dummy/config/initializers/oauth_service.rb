OauthService.setup do |config|
  available_providers = ["google", "yandex", "mail_ru"]

  available_providers.each do |provider|
    config.add_provider(
      provider.to_sym,
      "OauthService::Providers::#{provider.camelcase}".constantize
    ) do |provider_config|
      provider_config.auth_url = ENV["#{provider.upcase}_AUTH_URL"]
      provider_config.client_id = ENV["#{provider.upcase}_CLIENT_ID"]
      provider_config.client_secret = ENV["#{provider.upcase}_CLIENT_SECRET"]
      provider_config.info_url = ENV["#{provider.upcase}_INFO_URL"]
      provider_config.scopes = ENV["#{provider.upcase}_SCOPES"]
      provider_config.token_url = ENV["#{provider.upcase}_TOKEN_URL"]
    end
  end
end
