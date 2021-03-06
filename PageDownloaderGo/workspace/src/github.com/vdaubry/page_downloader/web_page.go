package main

import (
  "net/http"
  "log"
  "time"
  "github.com/streadway/amqp"
)

var requestSemaphore = make(chan int, 1000) // Max number of concurrent requests

type WebPage struct {
  Url      string
}

type HttpResponse struct {
  response  *http.Response
  err       error
  totalTime time.Duration
  message   amqp.Delivery
  url       string
}

func NewWebPage(url string) *WebPage {
  return &WebPage{Url: url}
}

func (page WebPage) Download(ch chan *HttpResponse, message amqp.Delivery) {
  requestSemaphore <- 1 // Block until put in the semaphore queue
  log.Printf("Fetching %s \n", page.Url)
  start_time := time.Now().UTC()
  timeout := time.Duration(15 * time.Second)
  client := http.Client{
    Timeout: timeout,
  }
  resp, err := client.Get(page.Url)
  ch <- &HttpResponse{resp, err, time.Since(start_time), message, page.Url}
  <- requestSemaphore // Dequeue from the semaphore
}