require 'spec_helper'
require 'figaro'

RSpec.describe Smartfileapi do
  before do
    Figaro.application = Figaro::Application.new(environment: 'development',
                                                 path: File.expand_path('../../application.yml', __FILE__))
    Figaro.application.load
    @smartfile_test = Smartfileapi::Services.new
  end

  describe 'version' do
    it 'has a version number' do
      expect(Smartfileapi::VERSION).not_to be nil
    end
  end

  describe 'config' do
    it 'has been configured properly' do
      expect(ENV.key?('SMARTFILE_KEY') && ENV.key?('SMARTFILE_PASSWORD')).to be true
    end

    it 'has pinged the server' do
      expect(@smartfile_test.ping_server[:ping]).to eq 'pong'
    end
  end

  describe 'whoami' do

    before do
      @smartfile_test_whoami = @smartfile_test.whoami
    end

    it 'has a valid IP' do
      expect(@smartfile_test_whoami[:address]).to match(/(\d{1,}\.){3}\d{1,3}/)
    end

    it 'has correct user' do
      expect(@smartfile_test_whoami[:user][:username]).to eq ENV['SMARTFILE_USERNAME']
    end

    it 'has site' do
      expect(@smartfile_test_whoami[:site].nil?).not_to be true
    end
  end
end
