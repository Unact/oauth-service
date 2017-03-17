require 'helpers/spec_helper'
require 'helpers/uri_params_helper'

RSpec.feature "the login process", :js => true do
  context 'signs me in' do

    def visit_login
      visit "login?#{to_params_string(login_client_params(@oauth_client))}"
    end

    before :each do
      @oauth_client = create(:oauth_client)
    end

    after :each do
      uri = URI.parse(page.current_url)
      code = uri.query.split('code=').last
      uri.query = uri.fragment = nil
      auth_code = OauthService::OauthAuthorizationCode.find_by_code(code)

      expect(auth_code).to_not eq(nil)
      expect(auth_code.oauth_client_id).to eq(@oauth_client.id)
      expect(uri.to_s).to eq(@oauth_client.redirect_uri)
    end

    it "google" do
      @oauth_user = create(:google_user)
      visit_login
      click_button 'Sign In with Google'
      fill_in "Email", with: ENV["GOOGLE_TEST_USER_LOGIN"]
      click_on "next"
      fill_in "Passwd", with: ENV["GOOGLE_TEST_USER_PASSWORD"]
      click_on "signIn"
      click_on "submit_approve_access"
    end

    it "yandex" do
      @oauth_user = create(:yandex_user)
      visit_login
      click_button 'Sign In with Yandex'
      fill_in "login", with: ENV["YANDEX_TEST_USER_LOGIN"]
      fill_in "passwd", with: ENV["YANDEX_TEST_USER_PASSWORD"]
      click_button "Войти"
    end

    it "mail_ru" do
      @oauth_user = create(:mail_ru_user)
      visit_login
      click_button 'Sign In with Mail Ru'
      fill_in "login", with: ENV["MAIL_RU_TEST_USER_LOGIN"]
      fill_in "password", with: ENV["MAIL_RU_TEST_USER_PASSWORD"]
      click_button "Log in and allow"
    end
  end
end
