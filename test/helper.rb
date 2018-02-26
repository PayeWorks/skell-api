ENV['RACK_ENV'] = 'test'
ENV['SESSION_SECRET'] = rand(36**41).to_s(36)

require 'minitest/autorun'
require 'rack/test'
require 'database_cleaner'
require 'pry'

require File.expand_path '../../app.rb', __FILE__
require_relative 'spawners'

include Rack::Test::Methods

DatabaseCleaner.clean_with :truncation

DatabaseCleaner.strategy = :transaction

class Minitest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end

def app
  Cuba
end