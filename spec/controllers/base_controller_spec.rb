require "helpers/spec_helper"

RSpec.describe OauthService::BaseController, :type => :controller do
  routes { OauthService::Engine.routes }
  before :each do
    @test_uri = "http://www.google.com"
  end

  def create_test_user_session
    test_email = "test_user@gmail.com"
    test_user = User.create(
      :email => test_email,
      :access_token => "test_token",
      :access_token_expires => Date.tomorrow
    )
    session[:user_email] = test_email
    session[:user_name] = test_email
    test_user
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
        test_user = create_test_user_session
        get :logout
        test_user.reload
        expect(test_user.access_token_expires).to eq(nil)
        expect(test_user.access_token).to eq(nil)
        expect(session.empty?).to eq(true)
      end
    end
  end

  describe "GET info" do
    context "with access_token" do
      before :each do
        @test_user = create_test_user_session
      end

      context "correct" do
        it "has a 200 status" do
          get :info, {:access_token => @test_user.access_token }
          expect(response.status).to eq(200)
        end
      end

      context "incorrect" do
        context "wrong token" do
          it "has a 401 status" do
            get :info, {:access_token => 'incorrect_token'}
            expect(response.status).to eq(401)
          end
        end

        context "expired token" do
          it "has a 401 status" do
            @test_user.access_token_expires = Date.yesterday
            @test_user.save
            get :info, {:access_token => @test_user.access_token}
            expect(response.status).to eq(401)
          end
        end
      end
    end
    context "without access_token" do
      it "has a 400 status" do
        get :info
        expect(response.status).to eq(400)
      end
    end
  end
end
