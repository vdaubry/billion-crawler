class Downloader
  def initialize
    @download_queue = Facades::Queue.new(queue_name: "download_queue")
    @process_queue = Facades::Queue.new(queue_name: "process_queue")
    @link_queue = Facades::Queue.new(queue_name: "link_queue")
    @storage = Facades::Storage.new
  end
  
  def start
    puts "Starts polling queue"
    @download_queue.poll do |msg|
      puts "received msg : #{msg}"
      msg = JSON.parse(msg)
      page = WebPage.new(url: msg["url"])
      store(page: page)
      send(page: page)
      extract(page: page)
    end
  end
  
  def store(page:)
    @storage.store(key: page.key, data: page.data)
  end
  
  def send(page:)
    @process_queue.send(msg: {key: page.key}.to_json)
  end
  
  def extract(page:)
    links = LinkExtractor.new(html: page.data).extract
    links.each do |link|
      @link_queue.send(msg: {href: link}.to_json)
    end
  end
end