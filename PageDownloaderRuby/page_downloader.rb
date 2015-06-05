$:.unshift File.dirname(__FILE__)

if ENV['APP_ENV']!="production"
  require 'byebug' 
  require 'dotenv'
  Dotenv.load
end

require 'aws-sdk'
require 'json'
require 'mechanize'
require 'celluloid'

# Classes
require "classes/downloader.rb"
require "classes/web_page.rb"
require "classes/link_extractor.rb"

# Facades
require "classes/facades/queue.rb"
require "classes/facades/sqs/client.rb"
require "classes/facades/storage.rb"
require "classes/facades/s3/client.rb"