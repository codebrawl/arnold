require 'mongoid'
require 'active_record'
require 'mocha'
require 'arnold'

require File.expand_path(File.dirname(__FILE__) + "/arnold_examples")

RSpec.configure do |config|
  config.mock_with :mocha
end