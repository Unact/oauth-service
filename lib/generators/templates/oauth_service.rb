OauthService.setup do |config|
  # The relative route where auth service callback is redirected.
  # config.callback_uri = "/"

  # The relative route where user is sent after login
  # config.redirect_uri = "/login/"

  # Providers used by OauthService
  # Write in this format:
  # config.provider(:provider_name_downcased, provider_class) do |provider_config|
  #   provider_config.auth_url = ...
  #   provider_config.client_id = ...
  #   provider_config.client_secret = ...
  #   provider_config.info_url = ...
  #   provider_config.scopes = ...
  #   provider_config.token_url = ...
  # end

  # Default OauthService logo
  # config.login_logo = "logo.png"

  # User info can be accessed until login_date + access_token_valid_for
  # config.access_token_valid_for = 1.day

  # Access token can be retrieved until login_date + code_valid_for
  # config.code_valid_for = 1.hour
end
