module OauthService
  module Errors

    def self.base data, status
      OauthService::Response.new(data, status)
    end

    def self.with_description error, description, status
      base({:error => error, :error_description => description}, status)
    end

    def self.invalid_request description = 'Bad Request', status = 400
      with_description 'invalid_request', description, status
    end

    def self.invalid_token_with_description description = 'Invalid Access Token' , status = 400
      with_description 'invalid_token', description, status
    end

    def self.invalid_grant_type
      invalid_request 'Wrong grant type'
    end

    def self.expired_token
      invalid_token_with_description 'Expired Access Token', 401
    end

    def self.invalid_token
      invalid_token_with_description 'Invalid Access Token', 401
    end

    def self.invalid_code
      invalid_request 'Invalid code or Refresh Token'
    end

    def self.invalid_client
      invalid_request 'Invalid Client parameters'
    end

    def self.invalid_user
      invalid_request 'No such User'
    end

    def self.server_error
      with_description 'server_error', 'Something wrong happened', 500
    end
  end
end
