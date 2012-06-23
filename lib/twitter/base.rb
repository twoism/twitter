require 'twitter/identity_map'
require 'twitter/rate_limitable'

module Twitter
  class Base
    include Twitter::RateLimitable
    attr_reader :attrs, :response_headers
    alias body attrs
    alias to_hash attrs
    alias headers response_headers

    @@identity_map = IdentityMap.new

    # Define methods that retrieve the value from an initialized instance variable Hash, using the attribute as a key
    #
    # @overload self.    attr_reader(attr)
    #   @param attr [Symbol]
    # @overload self.    attr_reader(attrs)
    #   @param attrs [Array<Symbol>]
    def self.attr_reader(*attrs)
      attrs.each do |attribute|
        class_eval do
          define_method attribute do
            @attrs[attribute.to_s]
          end
        end
      end
    end

    def self.fetch(attrs)
      attrs ||= {}
      @@identity_map[self] ||= {}
      @@identity_map[self][Marshal.dump(attrs)]
    end

    def self.from_response(response={})
      self.fetch(response[:body]) || self.new(response)
    end

    # Initializes a new object
    #
    # @param response [Hash]
    # @return [Twitter::Base]
    def initialize(response={})
      self.update_from_response!(response)
      @@identity_map[self.class] ||= {}
      @@identity_map[self.class][Marshal.dump(response[:body])] = self
    end

    # Fetches an attribute of an object using hash notation
    #
    # @param method [String, Symbol] Message to send to the object
    def [](method)
      self.send(method.to_sym)
    rescue NoMethodError
      nil
    end

    # Update the attributes of an object
    #
    # @param response [Hash]
    # @return [Twitter::Base]
    def update_from_response!(response)
      @attrs ||= {}
      @attrs.merge!(response[:body]) if response[:body]
      @response_headers ||= {}
      @response_headers.merge!(response[:response_headers]) if response[:response_headers]
      self
    end

  end
end
