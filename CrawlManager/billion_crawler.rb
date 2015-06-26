$:.unshift File.dirname(__FILE__)

if ENV['APP_ENV']!="production"
  require 'byebug' 
  require 'dotenv'
  Dotenv.load
end


## Crawler

require 'sidekiq'
require 'sidekiq/api'
require 'bloomfilter-rb'

#Initializers
require "initializers/redis"
require "initializers/sidekiq"
require "initializers/bloom_filter"

#Models
require "crawler/crawler"
require "crawler/scrapper_domain"
require "crawler/url_filter"
require "crawler/url_frontier"

#Interfaces
require "crawler/interfaces/downloader"

#Lib
require "crawler/lib/bloom_filter"

#Extensions
require "crawler/lib/extensions/uri"



## Downloader

require 'aws-sdk'
require 'json'
require 'mechanize'

# Classes
require "downloader/downloader.rb"
require "downloader/web_page.rb"
require "downloader/link_extractor.rb"

# Facades
require "downloader/facades/storage.rb"
require "downloader/facades/s3/client.rb"

#Interfaces
require "downloader/interfaces/crawler"


## PageProcessor

# Lib
require "page_processor/lib/vips/base.rb"
require "page_processor/lib/vips/in_memory.rb"
require "page_processor/lib/bloom_filter.rb"

# Classes
require "page_processor/processor.rb"
require "page_processor/web_page.rb"
require "page_processor/image.rb"

# Facades
require "page_processor/facades/storage.rb"
require "page_processor/facades/s3/client.rb"
