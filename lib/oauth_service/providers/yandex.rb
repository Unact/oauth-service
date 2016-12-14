module OauthService
  module Providers
    class Yandex < Provider
      def info(token_result)
        uri = URI.parse(self.info_url)
        headers = { "Authorization" => "OAuth #{token_result["access_token"]}" }

        info = self.send_request(uri, headers)
        if info[:errors].nil?
          {
            "email" => info["default_email"],
            "id" => info["id"],
            "name" => info["display_name"]
          }
        else
          info
        end
      end
    end
  end
end
