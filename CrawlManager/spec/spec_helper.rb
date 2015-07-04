require 'vcr'
require 'coveralls'
require 'stub_chain_mocha'
require 'dotenv'
require 'sidekiq/testing'
Coveralls.wear!
ENV["APP_ENV"]="test"

require_relative '../billion_crawler'

#push jobs in an array : https://github.com/mperham/sidekiq/wiki/Testing#testing-worker-queueing-fake
Sidekiq::Testing.fake!

$LOG = Logger.new('/dev/null')

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
  config.default_cassette_options = { :record => :new_episodes }
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.mock_with :mocha
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.order = 'random'
  
  config.around(:each) do |example|
    $redis.flushall
    example.run
  end
end
