module PageProcessor
  class ImageMessageBuilder < Struct.new(:website_url, :post_name, :post_url, :image)
    def to_json
      {
          "website": {
              "url": website_url
          },
           "post": {
               "name": post_name,
               "url": post_url
           },
           "image": {
               "src": image.src,
               "href": image.href,
               "scrapped_at": Time.now.to_s
           }.to_json
      }
    end
  end
end