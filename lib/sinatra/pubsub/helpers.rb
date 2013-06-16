require 'json'

module Sinatra
  module PubSub
    module Helpers extend self
      def publish(channel, message)
        Redis.publish(channel, message.to_json)
      end

      def publish_all(message)
        publish(:all, message)
      end

      def subscribe
        Thread.abort_on_exception = true

        trap('TERM') do
          Stream.disable!
          Process.kill('INT', $$)
        end

        Thread.new do
          Redis.subscribe
        end
      end
    end
  end
end