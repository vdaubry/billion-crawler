$:.unshift File.dirname(__FILE__)

if ENV['APP_ENV']!="production"
  require 'byebug' 
  require 'dotenv'
  Dotenv.load
  require 'sidekiq/api'
end

require 'mechanize'
require 'sidekiq'
require 'bloomfilter-rb'

#Initializers
require "initializers/redis"
require "initializers/sidekiq"
require "initializers/bloom_filter"
#Models
require "models/crawler"
require "models/link_extractor"
require "models/page_processor"
require "models/scrapper_page"
require "models/scrapper_domain"
#Workers
require "workers/fetch_url_worker"
require "workers/seed_worker"
#Lib
require "lib/scrapper_bloom_filter"
#Extensions
require "lib/extensions/uri"