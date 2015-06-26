module Downloader::Facades
  class Storage
    def initialize
      @storage = Downloader::Facades::S3::Client.new(bucket_name: "youboox_dev")
    end
    
    def store(key:, data:)
      puts "store #{key} on S3"
      @storage.put_object(key: "websites/#{key}", data: data)
    end
  end
end