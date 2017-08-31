require "smartfileapi/version"
require 'rest-client'
require 'json'

# Ruby implementation for the SmartFile API
module Smartfileapi

  BASE_URL = 'https://app.smartfile.com/api/2/'.freeze
  PING_URL = 'ping/'

  # All services
  class Services
    def initialize
      raise(ArgumentError, 'SmartFile KEY and(or) PASSWORD missing') if !ENV.key?('SMARTFILE_KEY') || !ENV.key?('SMARTFILE_PASSWORD')
      @smartfile_key = ENV['SMARTFILE_KEY'].freeze
      @smartfile_pass = ENV['SMARTFILE_PASSWORD'].freeze
    end

    # Ping API Server
    def ping_server
      request_res = request_resource PING_URL
      response = request_res.get

      { code: response.code,
        headers: response.headers,
        body: response.body,
        json: JSON.parse(response.body, symbolize_name: true),
        ping: :json[:ping] }
    end

    def request_resource(url)
      RestClient::Resource.new(BASE_URL + url, user: @smartfile_key, password: @smartfile_pass)
    end
  end
end
