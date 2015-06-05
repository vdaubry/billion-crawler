package main

func main() {
  rabbitClient := NewRabbitClient("amqp://guest:guest@localhost:5672/")
  rabbitClient.Listen("download_page")
}