require 'twitter/point'
require 'twitter/polygon'

module Twitter
  class GeoFactory

    # Instantiates a new geo object
    #
    # @param response [Hash]
    # @raise [ArgumentError] Error raised when supplied argument is missing a 'type' key.
    # @return [Twitter::Point, Twitter::Polygon]
    def self.from_response(response={})
      body = response[:body]
      if type = body.delete('type')
        Twitter.const_get(type.capitalize.to_sym).from_response(response)
      else
        raise ArgumentError, "argument must have a 'type' key"
      end
    end

  end
end
