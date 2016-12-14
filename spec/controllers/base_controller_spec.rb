require "helpers/spec_helper"

RSpec.describe OauthService::BaseController, :type => :controller do
  routes { OauthService::Engine.routes }
  before :each do
    @test_uri = "http://www.google.com"
  end
  def create_test_user
    @test_user = User.create(
      :name => 'test_user',
      :email => "test_user@gmail.com"
    )
  end
  def create_test_user_session
    create_test_user
    @test_user.update(
      :access_token => "test_token",
      :access_token_expires => Date.tomorrow
    )
    session[:user_email] = @test_user.email
    session[:user_name] = @test_user.name
    session[:access_token] = @test_user.access_token
  end

  describe "GET login" do
    before :each do
      get :login
    end

    it "has a 200 status code" do
      expect(response.status).to eq(200)
    end

    it "has only redirect_uri in session" do
      expect(session[:redirect_uri]).to eq(OauthService.redirect_uri)
    end

    it "has redirect_uri param in session" do
      get :login, {:redirect_uri => @test_uri}

      expect(session[:redirect_uri]).to eq(@test_uri)
    end
  end

  describe "GET logout" do
    it "was redirected to redirect_uri param" do
      get :logout, {:redirect_uri => @test_uri}

      expect(response).to redirect_to @test_uri
    end

    it "has empty session" do
      expect(session.empty?).to eq(true)
    end

    context "with logged user" do
      it "should log out user" do
        create_test_user_session

        get :logout
        @test_user.reload

        expect(@test_user.access_token_expires).to eq(nil)
        expect(@test_user.access_token).to eq(nil)
        expect(session.empty?).to eq(true)
      end
    end
  end

  describe "GET info" do
    before :each do
      request.headers["HTTP_ACCEPT"] = "application/json"
    end

    context "with access_token" do
      before :each do
        create_test_user_session
      end

      context "correct" do
        it "has a 200 status" do
          resp = {
            :user_name => @test_user.name,
            :user_email => @test_user.email
          }.to_json

          get :info, {:access_token => @test_user.access_token }

          expect(response.body).to eq(resp)
          expect(response.status).to eq(200)
        end
      end

      context "incorrect" do
        context "wrong token" do
          it "has a 401 status" do
            resp = {
              :error => 'Invalid Access Token',
              :code => 'invalid_token'
            }.to_json

            get :info, {:access_token => 'incorrect_token'}

            expect(response.body).to eq(resp)
            expect(response.status).to eq(401)
          end
        end

        context "expired token" do
          it "has a 401 status" do
            @test_user.access_token_expires = Date.yesterday
            @test_user.save
            resp =  {
              :error => 'Expired Access Token',
              :code => 'invalid_token'
            }.to_json

            get :info, {:access_token => @test_user.access_token}

            expect(response.body).to eq(resp)
            expect(response.status).to eq(401)
          end
        end
      end
    end
    context "without access_token" do
      it "has a 400 status" do
        resp = {
          :error => 'Access Token not sent',
          :code => 'invalid_request'
        }.to_json

        get :info

        expect(response.body).to eq(resp)
        expect(response.status).to eq(400)
      end
    end
  end

  describe "login method:" do
    before :each do
      create_test_user
      @user_info = { :name => 'TestUser', :email => 'test_user@gmail.com' }
      controller.instance_variable_set(:@user_info, @user_info)
    end

    context "login_user" do
      it "logs in" do
        controller.send(:login_user)

        expect(controller.instance_variable_get(:@user_info)).to eq(@user_info)
        expect(controller.instance_variable_get(:@user)).to eq(@test_user)
        expect(session[:user_name]).to eq(@test_user.name)
        expect(session[:user_email]).to eq(@test_user.email)
      end

      it "doesn't log in" do
        @user_info = { :error => 'test_error'}
        controller.instance_variable_set(:@user_info, @user_info)

        controller.send(:login_user)

        expect(controller.instance_variable_get(:@user)).to eq(nil)
        expect(session.empty?).to eq(true)
      end
    end

    context "update_user_access_token" do
      before :each do
        @test_access_token = "test_access_token"
        allow(controller).to receive(:generate_access_token).and_return(@test_access_token)
      end

      it "has correct data" do
        controller.instance_variable_set(:@user, @test_user)

        controller.send(:update_user_access_token)

        expect(session[:access_token]).to eq(@test_access_token)
        expect(@test_user.access_token).to eq(@test_access_token)
        expect(@test_user.access_token_expires).to eq(Date.today + OauthService.token_expire)
      end

      it "has incorrect data" do
        @test_user.update(access_token: @test_access_token)
        test_user2 = User.create(
          name: 'test_user2',
          email: 'test_user2@gmail.com'
        )
        controller.instance_variable_set(:@user, test_user2)

        controller.send(:update_user_access_token)

        expect(session[:access_token]).to eq(nil)
        expect(controller.instance_variable_get(:@user).access_token).to eq(nil)
        expect(controller.instance_variable_get(:@user_info)[:error]).to_not eq(nil)
      end
    end
  end
end
