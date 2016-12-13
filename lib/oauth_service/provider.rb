module OauthService
  class Provider
    attr_reader :name, :auth_url, :client_id, :client_secret,
      :info_url, :scopes, :token_url

    def initialize(name, auth_url, client_id, client_secret,
      info_url, scopes, token_url)
      @name = name
      @auth_url = auth_url
      @client_id = client_id
      @client_secret = client_secret
      @info_url = info_url
      @scopes = scopes
      @token_url = token_url
    end

    def callback_uri request_url
      uri = URI.parse(request_url)
      uri.path = OauthService.callback_uri + name.downcase
      uri.query = nil

      uri.to_s
    end

    def auth_uri request_url
      uri = URI.parse(auth_url)
      uri.query = URI.encode_www_form(auth_params(request_url))

      uri.to_s
    end

    def auth_params request_url
      {
        "client_id" => client_id,
        "redirect_uri" => callback_uri(request_url),
        "response_type" => "code",
        "scope" => scopes
      }
    end

    def token_params options = {}
      {
        "client_id" => client_id,
        "client_secret" => client_secret,
        "redirect_uri" => callback_uri(options[:original_url]),
        "grant_type" => "authorization_code",
        "code" => options[:code]
      }
    end

    def user_info callback_uri, code
      token_res = self.access_token(callback_uri, code)
      token_res[:error].nil? ? self.info(token_res) : token_res
    end

    def access_token callback_uri, code
      uri = URI.parse(self.token_url)
      uri.query = URI.encode_www_form(self.token_params(original_url: callback_uri, code: code))

      send_request(uri, nil, "POST")
    end

    def info token_res
      {}
    end

    protected
      def send_request(uri, headers, method="GET")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true if uri.scheme == "https"

        http.start do |http_info_request|
          res = http_info_request.send_request(
            method,
            uri.request_uri,
            uri.query == "" ? nil : uri.query,
            headers)

          res_body = res.body != "" ? ActiveSupport::JSON.decode(res.body) : {}

          unless res.is_a? Net::HTTPSuccess
            {
              :error => res_body["error"],
              :status => res.code
            }
          else
            res_body
          end
        end
      end
  end
end
