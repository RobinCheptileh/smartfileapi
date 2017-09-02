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

  # All services
  class Services
    def initialize
      raise(ArgumentError, 'SmartFileApi::Services: SmartFile KEY and(or) PASSWORD missing') if !ENV.key?('SMARTFILE_KEY') || !ENV.key?('SMARTFILE_PASSWORD')
      @smartfile_key = ENV['SMARTFILE_KEY'].freeze
      @smartfile_pass = ENV['SMARTFILE_PASSWORD'].freeze
      raise(ArgumentError, 'SmartFileApi::Services: Authentication failed') if whoami[:code] != 200
    end

    # Ping API Server
    def ping
      response = request_resource(PING_URL).get
      json = JSON.parse(response.body, symbolize_names: true)
      put_normals(response).merge(ping: json[:ping])
    end

    # Get current user's identity
    def whoami
      response = request_resource(WHOAMI_URL).get
      json = JSON.parse(response.body, symbolize_names: true)
      put_normals(response).merge(address: json[:address],
                                  user: json[:user],
                                  site: json[:site])
    end

    # Get current session expiry in seconds
    def session
      response = request_resource(SESSION_URL).get
      json = JSON.parse(response.body, symbolize_names: true)
      put_normals(response).merge(expires: json[:expires])
    end

    # List specified options
    def list(option, params = '')
      url = case option
            when :activities then ACTIVITY_URL
            when :links then LINK_URL
            when :tasks then TASK_URL
            else raise(ArgumentError, "SmartFileApi::Services.list: Invalid option '#{option}' argument")
            end
      response = request_resource(url).get(params: params)
      json = JSON.parse(response.body, symbolize_names: true)
      put_normals(response).merge(total: json[:total],
                                  page: json[:page],
                                  pages: json[:pages],
                                  per_page: json[:per_page],
                                  previous: json[:previous],
                                  next: json[:next],
                                  results: json[:results])
    end

    # Create links
    def create_link(params)
      response = request_resource(LINK_URL).post(params)
      json = JSON.parse(response.body, symbolize_names: true)
      put_normals(response).merge(acl: json[:acl],
                                  created: json[:created],
                                  expiration: json[:expiration],
                                  href: json[:href],
                                  name: json[:name],
                                  owner: json[:owner],
                                  path: json[:path],
                                  recursive: json[:recursive],
                                  uid: json[:uid],
                                  usage_count: json[:usage_count],
                                  usage_limit: json[:usage_limit],
                                  cache: json[:cache])
    end

    private

    def put_normals(response)
      raise("SmartFileApi::Services: Error code #{response.code}") unless [200, 201].include?(response.code)
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
