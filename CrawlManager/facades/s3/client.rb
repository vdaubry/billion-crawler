module Facades::S3
  class Client
    def initialize(bucket_name:)
      return if ENV["APP_ENV"]=="test"
      
      Aws.config.update({
        access_key_id: ENV['ACCESS_KEY_ID'],
        secret_access_key: ENV['SECRET_ACCESS_KEY'],
        region: 'us-east-1'
      })
      @s3 = Aws::S3::Client.new
      @bucket_name = bucket_name
    end
    
    def put_object(key:, data:)
      return if ENV["APP_ENV"]=="test"

      @s3.put_object(bucket: @bucket_name, 
                      acl: "private",
                      key: key,
                      body: data)
    end

    def get_object(key:)
      return if ENV["APP_ENV"]=="test"

      @s3.get_object(bucket: @bucket_name, 
                      key: key)
    end

    def delete_object(key:)
      return if ENV["APP_ENV"]=="test"

      @s3.delete_object(bucket: @bucket_name, 
                      key: key)
    end
  end
end