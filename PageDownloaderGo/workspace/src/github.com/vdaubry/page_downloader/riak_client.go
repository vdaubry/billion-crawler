package main

import (
    "log"
    "github.com/tpjg/goriakpbc"
)

type RiakClient struct {
  bucket *riak.Bucket
}

func NewRiakClient(bucketName string) *RiakClient {
  bucket := connectRiak(bucketName)
  return &RiakClient{bucket}
}

func connectRiak(bucketName string) *riak.Bucket {
  err := riak.ConnectClient("127.0.0.1:11087")
  if err != nil {
      log.Fatal("Cannot connect, is Riak running?")
      return nil
  }

  bucket, _ := riak.NewBucket(bucketName)
  
  return bucket
}

func (client RiakClient) PutObject(key string, data []byte) {
  log.Printf("Put %s with %d bytes", key, len(data))
  obj := client.bucket.NewObject(key)
  obj.ContentType = "text/html"
  obj.Data = data
  obj.Store()
}