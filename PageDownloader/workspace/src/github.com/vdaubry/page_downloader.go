package main

func main() {
  rabbitClient := NewRabbitClient("amqp://guest:guest@54.83.30.48:5672/")
  rabbitClient.Listen("download_page")
}