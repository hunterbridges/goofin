require 'net/http'
require 'json'

module IFTTT
  class MakerChannel
    def initialize(config)
      @key = config[:maker_channel_key]
    end

    def trigger(event, params)
      url = "https://maker.ifttt.com/trigger/#{event}/with/key/#{@key}"
      uri = URI.parse(url)

      req = Net::HTTP::Post.new uri.path
      req.body = params.to_json

      res = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.ssl_version = :SSLv3
        http.request req
      end

      res.body
    end
  end
end
