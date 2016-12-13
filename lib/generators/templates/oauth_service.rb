OauthService.setup do |config|
  # The relative route where auth service callback is redirected.
  # config.callback_uri = "/callback/"

  # The relative route where user is sent after login
  # config.redirect_uri = "/login/"

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
  # config.providers_keys = {}

  # Defaults to "User"
  # config.user_model_name = "User"

  # Default OauthService logo
  # config.login_logo = "logo.png"

  # User info can be accessed until login_date + token_expire
  # config.token_expire = 1.day
end
