require "oauth_service/provider"
require "oauth_service/providers/google"
require "oauth_service/providers/yandex"
require "oauth_service/engine"
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

  # Providers to use
  # Defaults to {}
  mattr_accessor :providers
  @@providers = {}

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

  def self.add_provider provider_name, provider_class
    provider_configuration = OauthService::ProviderConfiguration.new
    yield provider_configuration

    provider_configuration_values = provider_configuration.instance_variables.collect do |var|
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

  class ProviderConfiguration
    attr_accessor :name, :auth_url, :client_id, :client_secret,
      :info_url, :scopes, :token_url
    def initialize
      @auth_url = nil
      @client_id = nil
      @client_secret = nil
      @info_url = nil
      @scopes = nil
      @token_url = nil
    end
  end
end
