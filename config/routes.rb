OauthService::Engine.routes.draw do
  get 'callback/:provider_name',  to: 'base#callback'
  get 'logout',  to: 'base#logout'
  get 'login', to: 'base#login'
  get 'info', to: 'base#info'
  get 'token', to: 'base#token'

  root to: 'base#login'
end
