require 'active_support/concern'
require 'securerandom'

module OauthService
  module Controller
    extend ActiveSupport::Concern

    def logout
      clear_user_session

      redirect_to params[:redirect_uri] || root_url
    end

    def login
      clear_user_session

      @base_url = request.base_url
      client = OauthClient.find_by({
        :redirect_uri => params[:redirect_uri],
        :client_id => params[:client_id]
      })
      @state = client && params[:response_type] == "code" ? client.client_id : nil

      render :template => 'oauth/login'
    end

    def callback
      user_info = user_provider_info
      if user_info.nil?
        @oauth_error = Errors.invalid_request
      elsif user_info[:errors].present?
        @oauth_error = Errors.base(user_info, 400)
        user_info = nil
      end

      before_login_user user_info
      login_user user_info
      after_login_user user_info

      create_client_code

      redirect_after_login
    end

    def token
      client = OauthClient.find_by({
        client_id: params[:client_id],
        client_secret: params[:client_secret],
        redirect_uri: params[:redirect_uri]
      })
      unless client
        response = Errors.invalid_client
      end

      oauth_authorization_code = OauthAuthorizationCode.
        where(oauth_client_id: client.try(:id)).
        find do |oauth_auth_code|
          if params[:code]
            oauth_auth_code.code == params[:code] && oauth_auth_code.code_expires > Time.now
          elsif params[:refresh_token]
            oauth_auth_code.refresh_token == params[:refresh_token]
          end
        end

      if oauth_authorization_code
        if oauth_access_token = OauthAccessToken.create_by_authorization_code(oauth_authorization_code)
          response = Response.new({
            access_token: oauth_access_token.access_token,
            refresh_token: oauth_authorization_code.refresh_token
          })
        else
          response = Errors.server_error
        end
      end

      if response.nil?
        response = Errors.invalid_code
      end

      if params[:grant_type] != 'authorization_code'
        response = Errors.invalid_grant_type
      end

      render_response response
    end

    def info
      auth_header = request.headers["Authorization"]
      access_token = auth_header ? auth_header.split("Oauth ")[-1] : nil
      oauth_access_token = OauthAccessToken.find_by_access_token(access_token)

      response = if oauth_access_token && access_token
        if oauth_access_token.expires > Time.now
          Response.new({
            :user_name => oauth_access_token.oauth_user.name,
            :user_email => oauth_access_token.oauth_user.email
          })
        else
          Errors.expired_token
        end
      else
        Errors.invalid_token
      end

      unless access_token
        response = Errors.invalid_request
      end

      render_response response
    end

    protected
      def clear_user_session
        session[:user_name] = nil
        session[:user_email] = nil
      end

      def render_response response
        render :json => response.data, :status => response.status
      end

      def login_user user_info
        unless @oauth_error
          if @oauth_user ||= OauthUser.find_by_email(user_info[:email])
            session[:user_name] = @oauth_user.name
            session[:user_email] = @oauth_user.email
          else
            @oauth_error = Errors.invalid_user
          end
        end
      end

      def redirect_after_login
        uri = @oauth_client ? @oauth_client.redirect_uri : (OauthService.redirect_uri || root_url)
        redirect_uri = URI.parse(uri)

        if @oauth_client
          if @oauth_error.nil? && @oauth_auth_code
            query = {code: @oauth_auth_code.code}
          elsif @oauth_error
            query = @oauth_error.data
          end

          redirect_uri.query = URI.encode_www_form(query)
        end

        redirect_to redirect_uri.to_s
      end

      def before_login_user user_info
      end

      def after_login_user user_info
      end

      def create_client_code
        @oauth_client = OauthClient.find_by_client_id(params[:state])
        if @oauth_client && @oauth_error.nil?
          @oauth_auth_code = OauthAuthorizationCode.create_by_client @oauth_client, @oauth_user
        end
      end

      def user_provider_info
        provider = OauthService.providers[params[:provider_name].to_sym]
        user_info = nil

        if provider
          user_info = provider.user_info(request.base_url, params[:code]).symbolize_keys
        end

        user_info
      end
  end
end
