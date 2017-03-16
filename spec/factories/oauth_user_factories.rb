FactoryGirl.define do
  factory :oauth_user, class: OauthService::OauthUser do
    id 1
    name "Test"
    email  "test@gmail.com"
  end

  factory :google_user, class: OauthService::OauthUser do
    id 2
    name "Test Google"
    email  ENV["GOOGLE_TEST_USER_LOGIN"]
  end

  factory :yandex_user, class: OauthService::OauthUser do
    id 3
    name "Test Yandex"
    email  ENV["YANDEX_TEST_USER_LOGIN"]
  end

  factory :mail_ru_user, class: OauthService::OauthUser do
    id 4
    name "Test MailRu"
    email  ENV["MAIL_RU_TEST_USER_LOGIN"]
  end
end
