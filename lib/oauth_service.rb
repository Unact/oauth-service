require "oauth_service/provider"
require "oauth_service/providers/google"
require "oauth_service/providers/yandex"
require "oauth_service/engine"
require "oauth_service/response"
require "oauth_service/errors"
require "rails"

module OauthService
  MAX_TOKEN_UPDATES = 100
  # The relative route where auth service callback is redirected.
  # Defaults to "/".
  mattr_accessor :callback_uri
  @@callback_uri = "/"

  # The relative route where user is sent after login
  # if :redirect_uri parameter is not set.
  # Should be changed to suit your app
  # Defaults to "/login".
  mattr_accessor :redirect_uri
  @@redirect_uri = "/login/"

  # Providers to use
  # Defaults to {}
  mattr_accessor :providers
  @@providers = {}

  # User info can be accessed until login_date + access_token_valid_for
  mattr_accessor :access_token_valid_for
  @@access_token_valid_for = 30.day

  # Access token can be retrieved until login_date + code_valid_for
  mattr_accessor :code_valid_for
  @@code_valid_for = 1.hour

  # Logo for login page
  # Default to OauthService logo
  mattr_accessor :login_logo
  @@login_logo = "logo.jpg"

  # Default way to set up OauthService. Run rails generate oauth_service:install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end

  def self.add_provider provider_name, provider_class
    provider_configuration = OauthService::ProviderConfiguration.new
    yield provider_configuration

    provider_configuration.instance_variables.collect do |var|
      value = provider_configuration.instance_variable_get(var)
      unless value
        raise "OauthService initialization error #{provider_name} : #{var} not defined"
      end
    end

    self.providers[provider_name] = provider_class.new(
      provider_name.to_s,
      provider_configuration.auth_url,
      provider_configuration.client_id,
      provider_configuration.client_secret,
      provider_configuration.info_url,
      provider_configuration.scopes,
      provider_configuration.token_url
    )
  end

  def self.generate_token
    SecureRandom.urlsafe_base64
  end
end
