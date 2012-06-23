require 'twitter/base'
require 'twitter/user'

module Twitter
  class Relationship < Twitter::Base

    # @return [Twitter::User]
    def source
      @source ||= Twitter::User.from_response(:body => @attrs['source'], :response_headers => self.response_headers) unless @attrs['source'].nil?
    end

    # @return [Twitter::User]
    def target
      @target ||= Twitter::User.from_response(:body => @attrs['target'], :response_headers => self.response_headers) unless @attrs['target'].nil?
    end

    # Update the attributes of an object
    #
    # @param response [Hash]
    # @return [Twitter::Base]
    def update_from_response!(response)
      @attrs ||= {}
      @attrs.merge!(response[:body]['relationship']) if response[:body] && response[:body]['relationship']
      @response_headers ||= {}
      @response_headers.merge!(response[:response_headers]) if response[:response_headers]
      self
    end

  end
end
