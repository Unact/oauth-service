module OauthService
  module Providers
    class MailRu < Provider
      def info(token_result)
        uri = URI.parse(self.info_url)
        uri_params = {
          'app_id' => client_id,
          'method' => 'users.getInfo',
          'secure' => 1,
          'session_key' => token_result["access_token"]
        }
        uri_params['sig'] = Digest::MD5.hexdigest(
          uri_params.collect { |v| v.join('=') }.join + client_secret
        )
        uri.query = URI.encode_www_form(uri_params)

        info = self.send_request(uri, {})
        # MailRu всегда возвращает массив, если пришел не массив значит возникла ошибка
        if info.is_a? Array
          {
            "email" => info.first["email"],
            "name" => info.first["first_name"] + " " + info.first["last_name"]
          }
        else
          info
        end
      end
    end
  end
end
