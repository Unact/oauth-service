require "oauth_service/provider"
require "oauth_service/providers"
require "oauth_service/providers/google"
require "oauth_service/providers/yandex"
require "oauth_service/engine"
require "securerandom"
require "rails"

module OauthService
  # The relative route where auth service callback is redirected.
  # Defaults to "/callback".
  mattr_accessor :callback_uri
  @@callback_uri = "/callback/"

  # The relative route where user is sent after login
  # if :redirect_uri parameter is not set.
  # Should be changed to suit your app
  # Defaults to "/login".
  mattr_accessor :redirect_uri
  @@redirect_uri = "/login/"

  # Oauth providers to use for Authorization
  # Defaults to [OauthService::Providers::Yandex, OauthService::Providers::Google]
  mattr_accessor :available_providers
  @@available_providers = [OauthService::Providers::Yandex, OauthService::Providers::Google]

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
  # Defaults to {}
  mattr_accessor :providers_keys
  @@providers_keys = {}

  # Defaults to "User"
  mattr_accessor :user_model_name
  @@user_model_name = "User"

  # User info can be accessed until login_date + token_expire
  mattr_accessor :token_expire
  @@token_expire = 1.day

  # Logo for login page
  # Default to OauthService logo
  mattr_accessor :login_logo
  @@login_logo = "logo.jpg"

  # Default way to set up OauthService. Run rails generate oauth_service:install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end

  def self.user_model
    self.user_model_name.constantize
  end
end
