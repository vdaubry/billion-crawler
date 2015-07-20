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
           "image": image.to_json
      }.to_json
    end
  end
end