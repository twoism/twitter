module Twitter
  module RateLimitable

    # @return [Integer]
    def rate_limit
      limit = @response_headers.values_at('x-ratelimit-limit', 'X-RateLimit-Limit').compact.first
      limit.to_i if limit
    end

    # @return [String]
    def rate_limit_class
      @response_headers.values_at('x-ratelimit-class', 'X-RateLimit-Class').compact.first
    end

    # @return [Integer]
    def rate_limit_remaining
      remaining = @response_headers.values_at('x-ratelimit-remaining', 'X-RateLimit-Remaining').compact.first
      remaining.to_i if remaining
    end

    # @return [Time]
    def rate_limit_reset_at
      reset = @response_headers.values_at('x-ratelimit-reset', 'X-RateLimit-Reset').compact.first
      Time.at(reset.to_i) if reset
    end

    # @return [Integer]
    def rate_limit_reset_in
      reset_at = rate_limit_reset_at
      [(reset_at - Time.now).ceil, 0].max if reset_at
    end

  end
end

