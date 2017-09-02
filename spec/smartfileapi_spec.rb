require 'spec_helper'
require 'figaro'

RSpec.describe SmartFileApi do
  before do
    Figaro.application = Figaro::Application.new(environment: 'development',
                                                 path: File.expand_path('../../application.yml', __FILE__))
    Figaro.application.load
    @smartfile_test = SmartFileApi::Services.new
  end

  describe 'version' do
    it 'has a version number' do
      expect(SmartFileApi::VERSION).not_to be nil
    end
  end

  describe 'config' do
    it 'has been configured properly' do
      expect(ENV.key?('SMARTFILE_KEY') && ENV.key?('SMARTFILE_PASSWORD')).to be true
    end

    it 'has pinged the server' do
      expect(@smartfile_test.ping[:ping]).to eq 'pong'
    end
  end

  describe '#whoami' do
    before do
      @smartfile_test_whoami = @smartfile_test.whoami
    end

    it 'has 200 response code' do
      expect(@smartfile_test_whoami[:code]).to be == 200
    end

    it 'has a valid IP' do
      expect(@smartfile_test_whoami[:address]).to match(/(\d+\.){3}\d{1,3}/)
    end

    it 'has correct user' do
      expect(@smartfile_test_whoami[:user][:username]).to eq ENV['SMARTFILE_USERNAME']
    end

    it 'has site' do
      expect(@smartfile_test_whoami[:site]).not_to be nil
    end
  end

  describe '#session' do
    before do
      @smartfile_test_session = @smartfile_test.session
    end

    it 'has 200 response code' do
      expect(@smartfile_test_session[:code]).to be == 200
    end

    it 'has session expiry' do
      expect(@smartfile_test_session[:expires]).not_to be nil
    end
  end

  describe '#list_activities' do
    before do
      @smartfile_test_activity = @smartfile_test.list(:activities)
    end

    it 'has 200 response code' do
      expect(@smartfile_test_activity[:code]).to be == 200
    end

    it 'has valid response' do
      expect(@smartfile_test_activity[:total]).to be >= 0
    end

    it 'has all response fields' do
      expect(@smartfile_test_activity.length).to be >= 10
    end

    it 'has valid response with parameters' do
      expect(@smartfile_test.list(:activities, action: 'path removed', limit: 5, user: ENV['SMARTFILE_USERNAME'])[:code]).to be == 200
    end
  end

  describe 'links' do
    describe '#list_links' do
      before do
        @smartfile_test_list_links = @smartfile_test.list(:links)
      end

      it 'has 200 response code' do
        expect(@smartfile_test_list_links[:code]).to be == 200
      end

      it 'has valid response' do
        expect(@smartfile_test_list_links[:results].length).to be >= 0
      end
    end

    describe '#create_links' do
      before do
        @smartfile_test_create_links = @smartfile_test.create_link(path: '/ruby',
                                                                   read: true,
                                                                   recursive: true,
                                                                   list: true,
                                                                   write: true)
      end

      it 'has 200 response code' do
        expect([200, 201].include?(@smartfile_test_create_links[:code])).to be true
      end

      it 'has all response fields' do
        expect(@smartfile_test_create_links.length).to be >= 10
      end
    end
  end

  describe 'tasks' do
    before do
      @smartfile_test_list_tasks = @smartfile_test.list(:tasks)
    end

    it 'has 200 response code' do
      expect(@smartfile_test_list_tasks[:code]).to be == 200
    end

    it 'has valid response' do
      expect(@smartfile_test_list_tasks[:results].length).to be >= 0
    end
  end
end
