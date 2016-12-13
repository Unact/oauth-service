module OauthService
  module Providers

    def self.list
      @@list ||= OauthService.available_providers.collect do |provider|
        provider_name = provider.name.split('::').last.downcase
        keys = OauthService.providers_keys[provider_name.to_sym]
        provider.new(
          provider_name,
          keys[:auth_url],
          keys[:client_id],
          keys[:client_secret],
          keys[:info_url],
          keys[:scopes],
          keys[:token_url]
        ) if !keys.nil? &&
          keys[:auth_url] &&
          keys[:client_id] &&
          keys[:client_secret] &&
          keys[:info_url] &&
          keys[:scopes] &&
          keys[:token_url]
      end.compact
    end

    def self.by_name(name)
      list.find { |provider| provider.name.downcase == name.downcase }
    end
  end
end
