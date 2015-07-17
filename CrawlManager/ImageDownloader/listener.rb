module ImageDownloader
  class Listener
    def listen
      Facades::Queue.new(queue_name: "image_download").poll do |msg|
        image = JSON.parse(msg)["image"]

      end
    end
  end
end