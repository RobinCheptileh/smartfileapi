require 'spec_helper'
require 'figaro'

RSpec.describe Smartfileapi do
  before do
    Figaro.application = Figaro::Application.new(environment: 'development',
                                                 path: File.expand_path('../../application.yml', __FILE__))
    Figaro.application.load
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
      expect(Smartfileapi.ping_server.ping).to eq 'pong'
    end
  end
end
