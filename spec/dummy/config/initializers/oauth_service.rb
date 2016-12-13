OauthService.setup do |config|
  # The relative route where auth service callback is redirected.
  # config.redirect_uri = "/oauth/"

  # Format of page after login/logout
  # config.request_format = "json"

  # Oauth providers to use for Authorization
  # config.available_providers = [OauthService::Providers::Yandex, OauthService::Providers::Google]


  # Keys used by Oauth service
  # Write in this format:
  # {
  #   :provider_name_downcased => {
  #     :auth_url => ...,
  #     :client_id => ...,
  #     :client_secret => ...,
  #     :info_url => ...,
  #     :scopes => ...,
  #     :token_url => ...
  #   }
  # }
  #
  config.token_expire = 1.month

  config.providers_keys = {
    :google => {
      :auth_url => ENV["GOOGLE_AUTH_URL"],
      :client_id => ENV["GOOGLE_CLIENT_ID"],
      :client_secret => ENV["GOOGLE_CLIENT_SECRET"],
      :info_url => ENV["GOOGLE_INFO_URL"],
      :scopes => ENV["GOOGLE_SCOPES"],
      :token_url => ENV["GOOGLE_TOKEN_URL"]
    },
    :yandex => {
      :auth_url => ENV["YANDEX_AUTH_URL"],
      :client_id => ENV["YANDEX_CLIENT_ID"],
      :client_secret => ENV["YANDEX_CLIENT_SECRET"],
      :info_url => ENV["YANDEX_INFO_URL"],
      :scopes => ENV["YANDEX_SCOPES"],
      :token_url => ENV["YANDEX_TOKEN_URL"]
    }
  }
end
