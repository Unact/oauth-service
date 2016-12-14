require 'active_support/concern'
require 'securerandom'

module OauthService
  module Controller
    extend ActiveSupport::Concern
    MAX_USER_UPDATE_FAILS = 100

    def callback
      provider = OauthService.providers[params[:provider_name].to_sym]
      @user_info = provider ? provider.user_info(request.base_url, params[:code]).symbolize_keys : {:error => 'invalid_request'}

      before_callback

      login_user

      after_callback
      render_callback
    end

    def logout
      OauthService.user_model.find_by_email(session[:user_email]).try(:update,
        {
          :access_token => nil,
          :access_token_expires => nil
        }
      )

      session.clear
      redirect_to params[:redirect_uri] || root_url
    end

    def login
      @base_url = request.base_url
      session.clear
      session[:redirect_uri] = params[:redirect_uri] || OauthService.redirect_uri

      render :template => 'oauth/login'
    end

    def info
      info = process_access_token params[:access_token]

      respond_to do |format|
        format.any(:json, :xml, :html) { render request.format.to_sym => info[:data], :status => info[:status] }
      end
    end

    protected
      def login_user
        if @user_info && @user_info[:error].nil?
          @user = OauthService.user_model.find_by_email(@user_info[:email])
          if @user
            session[:user_name] = @user[:name]
            session[:user_email] = @user[:email]
            @user_update_fails = 0
            update_user_access_token
          else
            @user_info = {:error => 'invalid_request'}
          end
        end
      end

      def update_user_access_token
        retry_count ||= 0
        session[:access_token] = generate_access_token

        @user.update(
          :access_token => session[:access_token],
          :access_token_expires => Date.today + OauthService.token_expire
        )
      rescue ActiveRecord::RecordNotUnique
        if (retry_count += 1) != MAX_USER_UPDATE_FAILS
          retry
        else
          @user.reload
          session[:access_token] = nil
          @user_info = {:error => 'invalid_request'}
        end
      end

      def generate_access_token
        SecureRandom.uuid
      end

      def process_access_token access_token
        message = {
          :status => 200
        }
        if access_token
          user = OauthService.user_model.find_by_access_token(access_token)
          if user
            if user.access_token_expires > Time.now
              message[:data] =  {
                :user_name => user.name,
                :user_email => user.email
              }
            else
              message[:data] =  {
                :error => 'Expired Access Token',
                :code => 'invalid_token'
              }
              message[:status] = 401
            end
          else
            message[:data] =  {
              :error => 'Invalid Access Token',
              :code => 'invalid_token'
            }
            message[:status] = 401
          end
        else
          message[:data] = {
            :error => 'Access Token not sent',
            :code => 'invalid_request'
          }
          message[:status] = 400
        end
        message
      end

      def render_callback
        redirect_uri = URI.parse(session[:redirect_uri])

        if @user_info[:error].nil?
          session[:redirect_uri] = nil
          uri_params = {access_token: @user.access_token}
        else
          uri_params = {error: @user_info[:error]}
          session.clear
        end
        redirect_uri.query = URI.encode_www_form(uri_params)

        redirect_to redirect_uri.to_s
      end

      def before_callback
      end

      def after_callback
      end

  end
end
