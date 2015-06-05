module Facades::S3
  class Client
    def initialize(bucket_name:)
      Aws.config.update({
        access_key_id: ENV['ACCESS_KEY_ID'],
        secret_access_key: ENV['SECRET_ACCESS_KEY'],
        region: 'us-east-1'
      })
      @s3 = Aws::S3::Client.new
      @bucket_name = bucket_name
    end
    
    def put_object(key:, data:)
      @s3.put_object(bucket: @bucket_name,
                      acl: "private",
                      key: key,
                      body: data)
    end
    
    def get_object(key:)
      @s3.get_object(bucket: @bucket_name,
                      key: key).body
    end
    
    def delete_object(key:)
      @s3.get_object(bucket: @bucket_name,
                      key: key)
    end
  end
end