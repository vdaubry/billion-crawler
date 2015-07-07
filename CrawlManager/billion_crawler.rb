$:.unshift File.dirname(__FILE__)

if ENV['APP_ENV']!="production"
  require 'byebug' 
  require 'dotenv'
  Dotenv.load
end

require 'sidekiq'
require 'sidekiq/api'
require 'aws-sdk'
require 'json'
require 'mechanize'
require 'vips'
require 'benchmark'
require 'librato/metrics'

require "initializers/logger"
require "initializers/redis"
require "initializers/sidekiq"
require "initializers/bloom_filter"

require "facades/storage"
require "facades/s3/client"
require "facades/queue"
require "facades/sqs/client"
require "facades/http_download_facade"
require "facades/metrics"

require 'crawler/crawler'
require 'downloader/downloader'
require 'page_processor/page_processor'

require "lib/vips/base"
require "lib/vips/in_memory"
require "lib/bloom_filter_facade"
require "lib/rules/parser"
require "lib/rules/host_config"
require "lib/safe_uri"
require "lib/extensions/uri"

