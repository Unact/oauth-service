require 'helpers/spec_helper'

RSpec.describe OauthService::Provider do
  before :each do
    @host_name = "https://localhost:3000"
    @provider_name = "test_provider"
    @auth_url = "https://www.test.com/auth"
    @client_id = "test_client_id"
    @client_secret = "test_client_secret"
    @scopes = "test scopes"
    @info_url ="https://www.test.com/info"
    @token_url ="https://www.test.com/token"

    @provider = OauthService::Provider.new(
      @provider_name,
      @auth_url,
      @client_id,
      @client_secret,
      @info_url,
      @scopes,
      @token_url)
  end

  context "has correct" do
    it "initialization" do
      expect(@provider.name).to eq(@provider_name)
      expect(@provider.auth_url).to eq(@auth_url)
      expect(@provider.client_id).to eq(@client_id)
      expect(@provider.client_secret).to eq(@client_secret)
      expect(@provider.scopes).to eq(@scopes)
      expect(@provider.token_url).to eq(@token_url)
    end

    it "callback uri" do
      callback_uri = @provider.callback_uri(@host_name)
      expect(callback_uri).to eq(@host_name + OauthService.callback_uri + @provider_name)
    end

    it "auth params" do
      auth_params = @provider.auth_params(@host_name)

      expect(auth_params["client_id"]).to eq(@client_id)
      expect(auth_params["redirect_uri"]).to eq(@provider.callback_uri(@host_name))
      expect(auth_params["response_type"]).to eq("code")
      expect(auth_params["scope"]).to eq(@scopes)
    end

    it "token params" do
      token_params = @provider.token_params({original_url: @host_name, code: 0})

      expect(token_params["client_id"]).to eq(@client_id)
      expect(token_params["client_secret"]).to eq(@client_secret)
      expect(token_params["redirect_uri"]).to eq(@provider.callback_uri(@host_name))
      expect(token_params["grant_type"]).to eq("authorization_code")
      expect(token_params["code"]).to eq(0)
    end
  end
end
