require 'smartfile-api/version'
require 'rest-client'
require 'json'

# Ruby implementation for the SmartFile API
module SmartFileApi
  BASE_URL = 'https://app.smartfile.com/api/2/'.freeze
  PING_URL = 'ping/'.freeze
  WHOAMI_URL = 'whoami/'.freeze
  SESSION_URL = 'session/'.freeze
  ACTIVITY_URL = 'activity/'.freeze
  LINK_URL = 'link/'.freeze
  TASK_URL = 'task/'.freeze
  PATH_INFO_URL = 'path/info/'.freeze

  # All services
  class Services
    def initialize
      raise(ArgumentError, 'SmartFileApi::Services.initialize: SmartFile KEY and(or) PASSWORD missing') if !ENV.key?('SMARTFILE_KEY') || !ENV.key?('SMARTFILE_PASSWORD')
      @smartfile_key = ENV['SMARTFILE_KEY'].freeze
      @smartfile_pass = ENV['SMARTFILE_PASSWORD'].freeze
      raise(ArgumentError, 'SmartFileApi::Services.initialize: Authentication failed') if whoami[:code] != 200
    end

    # Ping API Server
    def ping
      format_response(request_resource(PING_URL).get)
    end

    # Get current user's identity
    def whoami
      format_response(request_resource(WHOAMI_URL).get)
    end

    # Get current session expiry in seconds
    def session
      format_response(request_resource(SESSION_URL).get)
    end

    # List specified options
    def list(option, params = '')
      url = case option
            when :activities then ACTIVITY_URL
            when :links then LINK_URL
            when :tasks then TASK_URL
            else raise(ArgumentError, "SmartFileApi::Services.list: Invalid option '#{option}'")
            end
      format_response(request_resource(url).get(params: params))
    end

    # Create links
    def create_link(params)
      format_response(request_resource(LINK_URL).post(params))
    end

    # Retrieval of a path's metadata
    def get_path_info(path, params = '')
      url = PATH_INFO_URL + path
      format_response(request_resource(url).get(params: params))
    end

    private

    # Format the api call response
    def format_response(response)
      raise("SmartFileApi::Services.format_response: Error code #{response.code}") unless [200, 201].include?(response.code)
      { code: response.code,
        headers: response.headers,
        body: response.body }.merge(JSON.parse(response.body,
                                               symbolize_names: true))
    end

    # Create a http resource with url and basic auth credentials
    def request_resource(url)
      RestClient::Resource.new(BASE_URL + url, user: @smartfile_key, password: @smartfile_pass)
    end
  end
end
