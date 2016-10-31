# require devise for testing
require 'devise'

# include devise test methods
RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, :type => :controller
  config.include Warden::Test::Helpers
  Warden.test_mode!
end