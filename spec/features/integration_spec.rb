require 'helpers/spec_helper'

RSpec.feature "the login process", :js => true do
  before :each do
    @test_user = User.create(email: 'test@gmail.com')
    visit '/login'
  end

  context 'signs me in' do
    after :each do
      query = CGI.parse(URI.parse(current_url).query)
      access_token = query["access_token"][0]
      expect(access_token).to_not eq(nil)
      expect(@test_user.access_token).to eq(nil)
      expect(@test_user.access_token_expires).to eq(nil)
      @test_user.reload
      expect(@test_user.access_token).to eq(access_token)
      expect(@test_user.access_token_expires).to eq(Date.today + OauthService.token_expire)
    end

    it "google" do
      @test_user.email = ENV["GOOGLE_TEST_USER_LOGIN"]
      @test_user.save

      click_button 'Sign In with Google'
      fill_in "Email", with: ENV["GOOGLE_TEST_USER_LOGIN"]
      click_on "next"
      fill_in "Passwd", with: ENV["GOOGLE_TEST_USER_PASSWORD"]
      click_on "signIn"
      click_on "submit_approve_access"
    end

    it "yandex" do
      @test_user.email = ENV["YANDEX_TEST_USER_LOGIN"]
      @test_user.save

      click_button 'Sign In with Yandex'
      fill_in "login", with: ENV["YANDEX_TEST_USER_LOGIN"]
      fill_in "passwd", with: ENV["YANDEX_TEST_USER_PASSWORD"]
      click_button "Войти"
    end
  end
end
