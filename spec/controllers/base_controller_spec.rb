require "helpers/spec_helper"
require "helpers/uri_params_helper"

RSpec.describe OauthService::BaseController, :type => :controller do
  routes { OauthService::Engine.routes }

  def json_response
    JSON.parse(response.body)
  end

  def check_error_response
    expect(json_response["error"]).to eq(@error.data[:error])
    expect(json_response["error_description"]).to eq(@error.data[:error_description])
    expect(response.status).to eq(@error.status)
  end

  def check_empty_user_session
    expect(session[:user_name]).to eq(nil)
    expect(session[:user_email]).to eq(nil)
  end

  describe "GET /login" do
    before :each do
      @client = create(:oauth_client)
      get :login
    end

    it 'has a 200 status code' do
      expect(response.status).to eq(200)
    end

    it 'has empty user session' do
      check_empty_user_session
    end

    it 'has found client when sent correct params' do
      get :login, login_client_params(@client)
      expect(assigns(:state)).to eq(@client.client_id)
    end

    it 'has not found client when sent incorrect params' do
      expect(assigns(:state)).to eq(nil)
    end
  end

  describe "GET /logout" do
    it 'was redirected to redirect_uri param' do
      test_uri = "http://www.google.com"
      get :logout, {:redirect_uri => test_uri}

      expect(response).to redirect_to test_uri
    end

    it 'has empty session' do
      check_empty_user_session
    end
  end

  describe "GET /info" do
    def set_auth_header token
      request.headers["Authorization"] = "Oauth #{token}"
    end

    it 'should return user name and email' do
      oauth_access_token = create(:oauth_access_token)
      set_auth_header oauth_access_token.access_token

      get :info

      expect(json_response["user_name"]).to eq(oauth_access_token.oauth_user.name)
      expect(json_response["user_email"]).to eq(oauth_access_token.oauth_user.email)
    end

    context 'should return error' do
      after :each do
        check_error_response
      end

      it 'when no token is sent' do
        set_auth_header nil
        @error = OauthService::Errors.invalid_request

        get 'info'
      end

      it 'when wrong token is sent' do
        set_auth_header 'sdd'
        @error = OauthService::Errors.invalid_token

        get 'info'
      end

      it 'when expired token is sent' do
        oauth_access_token = create(:oauth_access_token, :expires => Time.now)
        set_auth_header oauth_access_token.access_token
        @error = OauthService::Errors.expired_token

        get 'info'
      end
    end
  end

  describe "GET /token" do
    before :each do
      @auth_code = create(:oauth_authorization_code)
    end

    it 'should return refresh_token and access_token' do
      get :token, token_client_params(@auth_code.oauth_client, @auth_code.code)

      expect(json_response["refresh_token"]).to eq(@auth_code.refresh_token)
      expect(json_response["access_token"]).to_not eq(nil)
      expect(response.status).to eq(200)
    end

    context 'should return error' do
      after :each do
        check_error_response
      end

      it 'when client params are wrong' do
        @auth_code.oauth_client.client_id = "wrong_id"
        @error = OauthService::Errors.invalid_client

        get :token, token_client_params(@auth_code.oauth_client, @auth_code.code)
      end

      it 'when code param is expired' do
        @auth_code.code_expires = Date.yesterday
        @auth_code.save
        @error = OauthService::Errors.invalid_code

        get :token, token_client_params(@auth_code.oauth_client, @auth_code.code)
      end

      it 'when refresh_token param is wrong' do
        @auth_code.code = nil
        @auth_code.refresh_token = nil
        @error = OauthService::Errors.invalid_code

        get :token, token_client_params(@auth_code.oauth_client, @auth_code.code).merge({:refresh_token => 'dd'})
      end

      it 'when grant_type is wrong' do
        @error = OauthService::Errors.invalid_grant_type

        get :token, token_client_params(@auth_code.oauth_client, @auth_code.code, 'wrong_type')
      end
    end
  end

  describe "METHODS: " do
    context "login_user:" do
      before :each do
        @oauth_user = create(:oauth_user)

        @test_user_info = {:name => 'test', :email => @oauth_user.email}
      end

      it "logs in when user is found" do
        controller.instance_variable_set(:@oauth_user, @oauth_user)

        controller.send(:login_user, @test_user_info)

        expect(session[:user_name]).to eq(@oauth_user.name)
        expect(session[:user_email]).to eq(@oauth_user.email)
      end

      it "doesn't log in when user is not found" do
        @oauth_user.email = ''
        @oauth_user.save

        controller.send(:login_user, @test_user_info)

        expect(controller.instance_variable_get(:@oauth_error).data).to eq(OauthService::Errors.invalid_user.data)
        check_empty_user_session
      end
    end
  end
end
