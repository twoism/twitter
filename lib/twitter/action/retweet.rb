require 'twitter/action/status'

module Twitter
  module Action
    class Retweet < Twitter::Action::Status

      # A collection of retweets
      #
      # @return [Array<Twitter::Status>]
      def target_objects
        @target_objects = Array(@attrs['target_objects']).map do |status|
          Twitter::Status.from_response(status)
        end
      end

      # A collection containing the retweeted user
      #
      # @return [Array<Twitter::User>]
      def targets
        @targets = Array(@attrs['targets']).map do |user|
          Twitter::User.from_response(user)
        end
      end

    end
  end
end
