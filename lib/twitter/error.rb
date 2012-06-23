require 'twitter/rate_limitable'

module Twitter
  # Custom error class for rescuing from all Twitter errors
  class Error < StandardError
    include Twitter::RateLimitable
    attr_reader :response_headers, :wrapped_exception
    alias headers response_headers

    def self.errors
      return @errors if defined? @errors
      array = descendants.map do |klass|
        [klass.const_get(:HTTP_STATUS_CODE), klass]
      end.flatten
      @errors = Hash[*array]
    end

    def self.descendants
      ObjectSpace.each_object(::Class).select{|klass| klass < self}
    end

    # Initializes a new Error object
    #
    # @param exception [Exception, String]
    # @param response_headers [Hash]
    # @return [Twitter::Error]
    def initialize(exception=$!, response_headers={})
      @response_headers = response_headers
      if exception.respond_to?(:backtrace)
        super(exception.message)
        @wrapped_exception = exception
      else
        super(exception.to_s)
      end
    end

    def backtrace
      @wrapped_exception ? @wrapped_exception.backtrace : super
    end

  end
end
