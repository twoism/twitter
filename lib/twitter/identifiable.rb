require 'twitter/base'

module Twitter
  class Identifiable < Base

    def self.fetch(response)
      response ||= {}
      body = response[:body] || {}
      id = body['id']
      @@identity_map[self] ||= {}
      id && @@identity_map[self][id] && @@identity_map[self][id].update_from_response!(response) || super(body)
    end

    def self.from_response(response={})
      self.fetch(response) || self.new(response)
    end

    # Initializes a new object
    #
    # @param response [Hash]
    # @return [Twitter::Base]
    def initialize(response={})
      if response[:body] && response[:body]['id']
        self.update_from_response!(response)
        @@identity_map[self.class] ||= {}
        @@identity_map[self.class][response[:body]['id']] = self
      else
        super
      end
    end

    # @param other [Twitter::Identifiable]
    # @return [Boolean]
    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    # @return [Integer]
    def id
      @attrs['id']
    end

  end
end
