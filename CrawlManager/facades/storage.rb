module Facades
  class Storage
    def initialize
      @storage = Facades::S3::Client.new(bucket_name: "photocrawler")
    end
    
    def store(key:, data:)
      $LOG.debug "store #{key} on S3"
      @storage.put_object(key: "websites/#{key}", data: data)
    end

    def download(key:)
      $LOG.debug "download #{key} from S3"
      @storage.get_object(key: "websites/#{key}")
    end

    def delete(key:)
      $LOG.debug "delete #{key} on S3"
      @storage.delete_object(key: "websites/#{key}")
    end
  end
end