module OauthService
  class Engine < ::Rails::Engine
    isolate_namespace OauthService

    initializer "oauth_service.assets.precompile" do |app|
      app.config.assets.precompile += %w(login.css logo.jpg)
    end
  end
end
