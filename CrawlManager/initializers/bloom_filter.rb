require 'bloomfilter-rb'

$bloom_filter = BloomFilter::Redis.new(size: 1437758757, # size of bit vector (171.39MB)
                                        hashes: 10, # number of hash functions => http://hur.st/bloomfilter?n=100000000&p=0.001
                                        seed: Time.parse("2015/05/09 14:30").to_i, #use a fixed seed to persist data
                                        server: { host: ENV['REDIS_HOST'], 
                                                  port: ENV['REDIS_PORT'], 
                                                  password: ENV['REDIS_PASSWORD'] 
                                                }) 