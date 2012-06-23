require 'twitter/creatable'
require 'twitter/identifiable'
require 'twitter/user'

module Twitter
  class List < Twitter::Identifiable
    include Twitter::Creatable
    attr_reader :description, :following, :full_name, :member_count,
      :mode, :name, :slug, :subscriber_count, :uri
    alias following? following

    # @return [Twitter::User]
    def user
      @user ||= Twitter::User.from_response(:body => @attrs['user'], :response_headers => self.response_headers) unless @attrs['user'].nil?
    end

  end
end
