require 'twitter/creatable'
require 'twitter/identifiable'
require 'twitter/user'

module Twitter
  class DirectMessage < Twitter::Identifiable
    include Twitter::Creatable
    attr_reader :text

    # @return [Twitter::User]
    def recipient
      @recipient ||= Twitter::User.from_response(:body => @attrs['recipient'], :response_headers => self.response_headers) unless @attrs['recipient'].nil?
    end

    # @return [Twitter::User]
    def sender
      @sender ||= Twitter::User.from_response(:body => @attrs['sender'], :response_headers => self.response_headers) unless @attrs['sender'].nil?
    end

  end
end
