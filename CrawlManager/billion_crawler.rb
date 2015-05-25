$:.unshift File.dirname(__FILE__)

if ENV['APP_ENV']!="production"
  require 'byebug' 
  require 'dotenv'
  Dotenv.load
end

require 'sidekiq'
require 'sidekiq/api'
require 'bloomfilter-rb'
require 'bunny'

#Initializers
require "initializers/redis"
require "initializers/sidekiq"
require "initializers/bloom_filter"
#Models
require "models/crawler"
require "models/scrapper_domain"
require "models/rabbit_client"
require "models/url_filter"
require "models/url_frontier"
require "models/discovered_url_listener"
#Workers
require "workers/seed_worker"
#Lib
require "lib/scrapper_bloom_filter"
#Extensions
require "lib/extensions/uri"