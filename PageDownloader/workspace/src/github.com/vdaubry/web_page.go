package main

import (
  "net/http"
  "log"
  "time"
)

var requestSemaphore = make(chan int, 1000) // Max number of concurrent requests

type WebPage struct {
  url      string
}

type HttpResponse struct {
  response *http.Response
  err      error
  totalTime time.Duration
}

func NewWebPage(url string) *WebPage {
  return &WebPage{url: url}
}

func (page WebPage) Download(url string, ch chan *HttpResponse) {
  requestSemaphore <- 1 // Block until put in the semaphore queue
  log.Printf("Fetching %s \n", page.url)
  start_time := time.Now().UTC()
  timeout := time.Duration(15 * time.Second)
  client := http.Client{
    Timeout: timeout,
  }
  resp, err := client.Get(page.url)
  ch <- &HttpResponse{resp, err, time.Since(start_time)}
  <- requestSemaphore // Dequeue from the semaphore
}