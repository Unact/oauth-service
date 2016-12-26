module OauthService
  class Response
    attr_accessor :data, :status

    def initialize data, status = 200
      @data = data
      @status = status
    end
  end
end
