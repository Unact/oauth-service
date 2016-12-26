
def login_client_params oauth_client, response_type = 'code'
  {
    :redirect_uri => oauth_client.redirect_uri,
    :client_id => oauth_client.client_id,
    :response_type => response_type
  }
end

def token_client_params oauth_client, code, grant_type = 'authorization_code'
  {
    :client_id => oauth_client.client_id,
    :client_secret => oauth_client.client_secret,
    :redirect_uri => oauth_client.redirect_uri,
    :grant_type => grant_type,
    :code => code
  }
end

def to_params_string params
  params.collect{|key,value|"#{key}=#{value}"}.join('&')
end
