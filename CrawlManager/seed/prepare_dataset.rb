#!/usr/bin/env ruby

require 'eventmachine'
require 'em-http-request'
require 'dotenv'
require 'em-hiredis'
require 'byebug'
require 'json'

Dotenv.load

require_relative '../lib/extensions/uri'

class MeasureDomain
  def initialize
    @response_times = {}
  end
  
  def get_url(url:)
    puts "GET #{url}"
    @response_times[url] = Time.now.to_f
    page = EventMachine::HttpRequest.new(url).get
    page.errback { p "Couldn't get #{url}" }
    page.callback {
      total_time = Time.now.to_f - @response_times[url]
      @response_times.delete(url)
      puts "#{url} : #{page.response.size} bytes, total time : #{total_time}" 
      host = URI.parse(url).host_with_sublevel_domain
      $redis.zadd("bc:domains:perf", total_time, host) if page.response.size > 50
    }
  end
  
  def start
    
    puts "Loading urls from file"
    f = File.open("seed/top-websites.txt", 'r')
    urls = f.readlines
    n=0
    
    EM.run {
      EM.error_handler{ |e|
        puts "Error raised during event loop: #{e.message}"
      }
      
      $redis = EM::Hiredis.connect("redis://:#{ENV['REDIS_PASSWORD']}@#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}") 
      
      EM::PeriodicTimer.new(0.01) do
        EM.stop if n >= urls.size
        url = urls[n].gsub("\r\n", "")
        get_url(url: "http://#{url}")
        n+=1
      end
    }
  end
end

MeasureDomain.new.start