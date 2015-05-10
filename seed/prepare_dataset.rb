#!/usr/bin/env ruby

require_relative '../billion_crawler'

class MeasureDomain
  def initialize
    Sidekiq::Queue.new("seed").clear
  end
  
  def jobs_count
    Sidekiq::Queue.new("seed").size
  end
  
  def start
    f = File.open("seed/top-websites.txt", 'r')
    f.readlines.each do |domain|
      url = "http://#{domain.gsub("\r\n", "")}"
      SeedWorker.perform_async(url)
    end
  end
end

$redis.flushall
MeasureDomain.new.start