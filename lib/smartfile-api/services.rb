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
  PATH_DATA_URL = 'path/data/'.freeze
  PATH_PROGRESS_URL = 'path/progress/'.freeze
  PATH_MAP_URL = 'path/map/'.freeze
  PATH_ACCESS_URL = 'access/path/'.freeze
  PATH_SEARCH_URL = 'search/path/'.freeze
  PATH_NOTIFY_URL = 'watch/paths/'.freeze

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
      format_response(get_request(PING_URL))
    end

    # Get current user's identity
    def whoami
      format_response(get_request(WHOAMI_URL))
    end

    # Get current session expiry in seconds
    def session
      format_response(get_request(SESSION_URL))
    end

    # List specified options
    def list(option, params = {})
      url = case option
            when :activities then ACTIVITY_URL
            when :links then LINK_URL
            when :tasks then TASK_URL
            when :path_map then PATH_MAP_URL
            when :path_notifications then PATH_NOTIFY_URL
            else raise(ArgumentError, "SmartFileApi::Services.list: Invalid option '#{option}'")
            end
      format_response(get_request(url, params: params))
    end

    # Create links
    def create_link(params)
      format_response(post_request(LINK_URL, params))
    end

    # Retrieval of a path's metadata
    def get_path(option, path = '', params = {})
      url = case option
            when :info then PATH_INFO_URL + path
            when :data then PATH_DATA_URL + path
            when :progress then PATH_PROGRESS_URL + path
            when :map then PATH_MAP_URL
            when :access then PATH_ACCESS_URL + path
            when :notifications then PATH_NOTIFY_URL
            else raise(ArgumentError, "SmartFileApi::Services.get_path: Invalid option '#{option}'")
            end
      format_response(get_request(url, params: params))
    end

    # Search for paths matching criteria within a given scope (path).
    def search(path, params)
      url = PATH_SEARCH_URL + path
      format_response(get_request(url, params: params))
    end

    private

    # Format the api call response
    def format_response(response)
      # raise("SmartFileApi::Services.format_response: Error code #{response.code}: #{RestClient::STATUSES[response.code]}") unless [200, 201].include?(response.code)
      { request: { method: (response.request.method || ''),
                   uri: (response.request.uri || ''),
                   url: (response.request.url || ''),
                   headers: (response.request.headers || {}),
                   payload: (response.request.payload || {}),
                   user: (response.request.user || ''),
                   password: (response.request.password || ''),
                   raw_response: (response.request.raw_response || ''),
                   processed_headers: (response.request.processed_headers || {}),
                   args: (response.request.args || {}),
                   ssl_opts: (response.request.ssl_opts || {}) },
        code: response.code,
        headers: response.headers,
        body: response.body }.merge(JSON.parse(response.body,
                                               symbolize_names: true))
    end

    # Make a get request with ability to rescue errors
    def get_request(url, additional_headers = {})
      RestClient::Resource.new(BASE_URL + url, user: @smartfile_key, password: @smartfile_pass).get(additional_headers)
    rescue RestClient::Exception => e
      e.response
    end

    # Make a post request with ability to rescue errors
    def post_request(url, payload, additional_headers = {})
      RestClient::Resource.new(BASE_URL + url, user: @smartfile_key, password: @smartfile_pass).post(payload, additional_headers)
    rescue RestClient::Exception => e
      e.response
    end
  end
end