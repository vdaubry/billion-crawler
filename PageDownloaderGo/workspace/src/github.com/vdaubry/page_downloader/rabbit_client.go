package main

import (
  "fmt"
  "github.com/streadway/amqp"
  "log"
  "encoding/json"
  "time"
  //"net/url"
  "io/ioutil"
)

type RabbitClient struct {
  ch *amqp.Channel
}

func failOnError(err error, msg string) {
  if err != nil {
    log.Fatalf("%s: %s", msg, err)
    panic(fmt.Sprintf("%s: %s", msg, err))
  }
}

func connectRabbit(connectionString string) *amqp.Channel {
  conn, err := amqp.Dial(connectionString)
  failOnError(err, "Failed to connect to RabbitMQ")
  
  ch, err := conn.Channel()
  failOnError(err, "Failed to open a channel")

  err = ch.Qos(
    20,     // prefetch count
    0,     // prefetch size
    false, // global
  )
  failOnError(err, "Failed to set QoS")
  
  return ch
}

func (client RabbitClient) queue(queueName string) amqp.Queue {
  q, err := client.ch.QueueDeclare(
    queueName,    // name
    true,         // durable
    false,        // delete when unused
    false,        // exclusive
    false,        // no-wait
    nil,          // arguments
  )
  failOnError(err, "Failed to declare a queue")
  
  return q
}

func NewRabbitClient(connectionString string) *RabbitClient {
  ch := connectRabbit(connectionString)
  return &RabbitClient{ch}
}

func (client RabbitClient) Listen(queueName string) {
  q := client.queue(queueName)
  
  msgs, err := client.ch.Consume(
    q.Name, // queue
    "",     // consumer
    false,  // auto-ack
    false,  // exclusive
    false,  // no-local
    false,  // no-wait
    nil,    // args
  )
  failOnError(err, "Failed to register a consumer")
  
  responses := make(chan *HttpResponse)
  riak_client := NewRiakClient("html")
  
  log.Printf("Waiting for messages...")
  for {

    select {
    case message := <- msgs:
      webPage := &WebPage{}
      json.Unmarshal([]byte(message.Body), &webPage)
      log.Printf("Received url to download: %s", webPage.Url)
      go webPage.Download(responses, message)
      
    case response := <-responses:
      if response.err == nil {
        fmt.Printf("status: %s in %s\n",
               response.response.Status, response.totalTime)
        
        //Store page in riak
        //key,_ := url.Parse(response.url)
        key := response.url
        pageData,_ := ioutil.ReadAll(response.response.Body)
        riak_client.PutObject(key, pageData)
        
        //Send done msg to RabbitMQ
        type HtmlPageMessage struct {
          key string
        }
        doneMsg := HtmlPageMessage{key}
        jsonBody,_ := json.Marshal(doneMsg)
        Send("html_process", jsonBody)
        
        //Extract links from page
        parser := NewPageParser(pageData)
        links := parser.ParseLinksr()
        type LinksMessage struct {
          urls []string
        }
        linkMsg := LinksMessage{links}
        jsonBody,_ := json.Marshal(linkMsg)
        Send("new_links", jsonBody)
        
        response.message.Ack(false)
        
      } else {
        fmt.Printf("err: %s in %s\n", response.err, response.totalTime)
      } 
      
    default:
      //Max 1 msg / sec
      time.Sleep(1000 * time.Millisecond)
    }
    
  }
}

func (client RabbitClient) Send(queueName string, message []byte) {
  q := client.queue(queueName)
  
  err := client.ch.Publish(
    "",           // exchange
    q.Name,       // routing key
    false,        // mandatory
    false,
    amqp.Publishing{
      DeliveryMode: amqp.Persistent,
      ContentType:  "text/plain",
      Body:         message,
    })
  failOnError(err, "Failed to publish a message")
}