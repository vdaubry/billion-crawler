require 'vcr'
require 'coveralls'
require 'dotenv'
Coveralls.wear!
ENV["APP_ENV"]="test"

require_relative '../billion_crawler'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.mock_with :mocha
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.order = 'random'
end
