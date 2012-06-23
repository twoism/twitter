require 'twitter/core_ext/kernel'

module Twitter
  class Cursor
    attr_reader :attrs, :response_headers
    attr_accessor :collection
    alias body attrs
    alias to_hash attrs
    alias headers response_headers

    # Initializes a new Cursor object
    #
    # @param response [Hash]
    # @params method [String, Symbol] The name of the method to return the collection
    # @params klass [Class] The class to instantiate object in the collection
    # @return [Twitter::Cursor]
    def self.from_response(response={}, method='ids', klass=nil)
      cursor = self.new
      cursor.update_from_response!(response, method)
      cursor.collection = Array(response[:body][method.to_s]).map do |item|
        if klass
          klass.from_response(:body => item, :response_headers => response[:response_headers])
        else
          item
        end
      end
      instance_eval do
        alias_method(method.to_sym, :collection)
      end
      cursor
    end

    def next_cursor
      @attrs['next_cursor']
    end
    alias next next_cursor

    def previous_cursor
      @attrs['previous_cursor']
    end
    alias previous previous_cursor

    # @return [Boolean]
    def first?
      previous_cursor.zero?
    end
    alias first first?

    # @return [Boolean]
    def last?
      next_cursor.zero?
    end
    alias last last?

    # Update the attributes of an object
    #
    # @param response [Hash]
    # @return [Twitter::Cursor]
    def update_from_response!(response, method)
      @attrs ||= {}
      @attrs.merge!(response[:body]) if response[:body] && response[:body]
      @response_headers ||= {}
      @response_headers.merge!(response[:response_headers]) if response[:response_headers]
      self
    end

  end
end
