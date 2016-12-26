require "helpers/spec_helper"

RSpec.describe OauthService::OauthAuthorizationCode, :type => :model do
  context 'create_by_client' do
    before :each do
      @oauth_user = create(:oauth_user)
      @oauth_user2 = create(:google_user)
      @oauth_client = create(:oauth_client)
      @auth_code = create(
        :oauth_authorization_code,
        {
          oauth_user_id: @oauth_user.id,
          oauth_client_id: @oauth_client.id
        }
      )
    end

    it 'should return nil' do
      allow(OauthService).to receive(:generate_token).and_return('test_code')

      expect(OauthService::OauthAuthorizationCode.create_by_client(@oauth_client, @oauth_user2)).to eq(nil)
      expect(OauthService::OauthAuthorizationCode.all.length).to eq(1)
    end

    it 'should return created record' do
      expect(OauthService::OauthAuthorizationCode.create_by_client(@oauth_client, @oauth_user2)).to_not eq(nil)
      expect(OauthService::OauthAuthorizationCode.all.length).to eq(2)
    end
  end
end
