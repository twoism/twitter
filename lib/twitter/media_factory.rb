require 'twitter/photo'

module Twitter
  class MediaFactory

    # Instantiates a new media object
    #
    # @param response [Hash]
    # @raise [ArgumentError] Error raised when supplied argument is missing a 'type' key.
    # @return [Twitter::Photo]
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
