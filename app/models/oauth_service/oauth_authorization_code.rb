module OauthService
  class OauthAuthorizationCode < ActiveRecord::Base
    belongs_to :oauth_client
    belongs_to :oauth_user

    default_scope { includes(:oauth_user) }

    def self.create_by_client oauth_client, oauth_user
      retry_count ||= 0
      OauthAuthorizationCode.delete_all(
        oauth_client_id: oauth_client.id,
        oauth_user_id: oauth_user.id
      )
      self.create(
        code: OauthService.generate_token,
        code_expires: Time.now + OauthService.code_valid_for,
        refresh_token: OauthService.generate_token,
        oauth_client_id: oauth_client.id,
        oauth_user_id: oauth_user.id
      )
    rescue ActiveRecord::RecordNotUnique
      if (retry_count += 1) != OauthService::MAX_TOKEN_UPDATES
        retry
      else
        nil
      end
    end
  end
end
