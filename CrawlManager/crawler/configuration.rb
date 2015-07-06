module Crawler
  class Configuration
    #Deafult conf
    @@configuration = {"max_depth" => 1}

    def self.set(property_name:, value:)
      @@configuration[property_name] = value
    end
    
    def self.get(property_name:)
      @@configuration[property_name]
    end  
  end
end