module OauthService
  class OauthAccessToken < ActiveRecord::Base
    belongs_to :oauth_client
    belongs_to :oauth_user

    default_scope { includes(:oauth_user) }

    def self.create_by_authorization_code auth_code
      retry_count ||= 0
      auth_code.update(:code => nil, :code_expires => nil)
      self.create({
        access_token: OauthService.generate_token,
        expires: Time.now + OauthService.access_token_valid_for,
        oauth_user_id: auth_code.oauth_user_id,
        oauth_client_id: auth_code.oauth_client_id
      })
    rescue ActiveRecord::RecordNotUnique
      if (retry_count += 1) != OauthService::MAX_TOKEN_UPDATES
        retry
      else
        nil
      end
    end
  end
end
