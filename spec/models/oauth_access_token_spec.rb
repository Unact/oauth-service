require "helpers/spec_helper"

RSpec.describe OauthService::OauthAccessToken, :type => :model do
  context 'create_by_authorization_code' do
    before :each do
      @auth_code = create(:oauth_authorization_code)
      create(:oauth_access_token,
        {
          oauth_user_id: @auth_code.oauth_user_id,
          oauth_client_id: @auth_code.oauth_client_id
        }
      )
    end

    it 'should return nil' do
      allow(OauthService).to receive(:generate_token).and_return('test_access_token')

      expect(OauthService::OauthAccessToken.create_by_authorization_code(@auth_code)).to eq(nil)
      expect(@auth_code.code).to eq(nil)
      expect(OauthService::OauthAccessToken.all.length).to eq(1)
    end

    it 'should return created record' do
      expect(OauthService::OauthAccessToken.create_by_authorization_code(@auth_code)).to_not eq(nil)
      expect(@auth_code.code).to eq(nil)
      expect(OauthService::OauthAccessToken.all.length).to eq(2)
    end
  end
end
