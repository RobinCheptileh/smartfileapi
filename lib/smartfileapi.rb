require "smartfileapi/version"
require 'rest-client'

# Ruby implementation for the SmartFile API
module Smartfileapi

  # Set KEY and PASSWORD
  raise(ArgumentError, 'SmartFile KEY and(or) PASSWORD missing') if !ENV.key?('SMARTFILE_KEY') || !ENV.key?('SMARTFILE_PASSWORD')
  @smartfile_key = ENV['SMARTFILE_KEY'].freeze
  @smartfile_pass = ENV['SMARTFILE_PASSWORD'].freeze
  @login_resource = RestClient::Resource.new('https://app.smartfile.com/api/2/path/data/',
                                             user: @smartfile_key,
                                             password: @smartfile_pass)

  PING_URL = 'https://app.smartfile.com/api/2/ping/'.freeze

  # Ping API Server
  def self.ping_server
    resp = RestClient.get PING_URL
    response = Smartfileapi::Response.new
    response.headers = response.headers
    response.body = resp.body
    response.json = JSON.parse(resp.body, symbolize_name: true)
    response.ping = response.json.ping

    response
  end
end
