require "smartfileapi/version"
require 'rest-client'
require 'json'

# Ruby implementation for the SmartFile API
module Smartfileapi

  BASE_URL = 'https://app.smartfile.com/api/2/'.freeze
  PING_URL = 'ping/'.freeze
  WHOAMI_URL = 'whoami/'.freeze

  # All services
  class Services
    def initialize
      raise(ArgumentError, 'SmartFile KEY and(or) PASSWORD missing') if !ENV.key?('SMARTFILE_KEY') || !ENV.key?('SMARTFILE_PASSWORD')
      @smartfile_key = ENV['SMARTFILE_KEY'].freeze
      @smartfile_pass = ENV['SMARTFILE_PASSWORD'].freeze
    end

    # Ping API Server
    def ping_server
      response = request_resource(PING_URL).get
      json = JSON.parse(response.body, symbolize_names: true)
      put_normals(response).merge(ping: json[:ping])
    end

    # Get Current user's identity
    def whoami
      response = request_resource(WHOAMI_URL).get
      json = JSON.parse(response.body, symbolize_names: true)
      put_normals(response).merge(address: json[:address],
                                  user: json[:user],
                                  site: json[:site])
    end

    private

    def put_normals(response)
      json = JSON.parse(response.body, symbolize_names: true)
      { code: response.code,
        headers: response.headers,
        body: response.body,
        json: json }
    end

    def request_resource(url)
      RestClient::Resource.new(BASE_URL + url, user: @smartfile_key, password: @smartfile_pass)
    end
  end
end
