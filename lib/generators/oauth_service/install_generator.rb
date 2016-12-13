require "rails/generators/base"

module OauthService
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a OauthService initializer."
      
      def copy_initializer
        template "oauth_service.rb", "config/initializers/oauth_service.rb"
      end
    end
  end
end
