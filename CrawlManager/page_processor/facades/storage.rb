module Facades
  class Storage
    def initialize
      @storage = Facades::S3::Client.new(bucket_name: "youboox_dev")
    end
    
    def store(key:, data:)
      puts "store #{key} on S3"
      @storage.put_object(key: "images/#{key}", data: data)
    end
    
    def download(key:)
      puts "download #{key} on S3"
      @storage.get_object(key: "websites/#{key}")
    end
    
    def delete(key:)
      puts "delete #{key} on S3"
      @storage.delete_object(key: "websites/#{key}")
    end
  end
end