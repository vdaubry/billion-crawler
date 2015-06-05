$:.unshift File.dirname(__FILE__)

if ENV['APP_ENV']!="production"
  require 'byebug' 
  require 'dotenv'
  Dotenv.load
end

require 'aws-sdk'
require 'json'
require 'nokogiri'
require 'celluloid'
require 'net/http'
require 'uri'
require 'redis'
require 'bloomfilter-rb'
require 'time'
require 'vips'
require 'fastimage'

# Lib
require "classes/lib/vips/base.rb"
require "classes/lib/vips/in_memory.rb"
require "classes/lib/processor_bloom_filter.rb"

# Initializers
require "initializers/redis.rb"
require "initializers/bloom_filter.rb"

# Classes
require "classes/processor.rb"
require "classes/web_page.rb"
require "classes/image.rb"

# Facades
require "classes/facades/queue.rb"
require "classes/facades/sqs/client.rb"
require "classes/facades/storage.rb"
require "classes/facades/s3/client.rb"