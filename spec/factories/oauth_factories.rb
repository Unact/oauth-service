FactoryGirl.define do
  factory :oauth_client, class: OauthService::OauthClient do
    id 1
    name "Test"
    client_id "test_id"
    client_secret "test_secret"
    redirect_uri "http://localhost:3000/after_login"
  end

  factory :oauth_access_token, class: OauthService::OauthAccessToken do
    id 1
    oauth_user_id { create(:oauth_user).id }
    oauth_client_id { create(:oauth_client).id }
    access_token { 'test_access_token'}
    expires { Time.now + OauthService.access_token_valid_for }
  end

  factory :oauth_authorization_code, class: OauthService::OauthAuthorizationCode do
    id 1
    oauth_user_id { create(:oauth_user).id }
    oauth_client_id { create(:oauth_client).id }
    code { 'test_code' }
    refresh_token { 'test_refresh_token'}
    code_expires { Time.now + OauthService.code_valid_for }
  end
end
