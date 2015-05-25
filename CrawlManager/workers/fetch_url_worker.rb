class FetchUrlWorker
  include Sidekiq::Worker
   sidekiq_options :queue => :crawler, :retry => false, :backtrace => true
  
  def perform(url)
    begin
      puts "Get #{url}"
      scrapper_page = ScrapperPage.new(url: url)
      LinkExtractor.new(page: scrapper_page).extract
      PageProcessor.new(page: scrapper_page).process
    rescue StandardError => e
      puts "Couldn't get #{url} : #{e}"
    end
  end
end