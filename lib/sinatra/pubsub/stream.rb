module Sinatra
  module PubSub
    class Stream
      def self.streams
        @streams ||= Hash.new { |hash, key| hash[key] = [] }
      end

      def self.enabled?
        unless defined? @enabled
          @enabled = true
        end
        @enabled
      end

      def self.disable!
        @enabled = false
        streams.values.flatten.each(&:close!)
      end

      def self.publish(channel, message, options = {})
        streams = self.streams[channel.to_s]

        if except_id = options[:except]
          streams = streams.reject {|s| s.id == except_id }
        end

        streams.each {|c| c.publish(:message, message) }
      end

      def self.publish_all(message, options = {})
        publish(:all, message, options)
      end

      attr_reader :out, :id

      def initialize(out)
        @id       = SecureRandom.uuid
        @out      = out

        subscribe :all

        @timer = EventMachine::PeriodicTimer.new(
          20, method(:keepalive)
        )

        setup
      end

      def subscribe(channel)
        self.class.streams[channel.to_s] << self
      end

      def close!
        @timer.cancel

        self.class.streams.each do |channel, streams|
          streams.delete(self)
        end
      end

      def publish(event, message)
        self << "event: #{event}\n"
        self << "data: #{message}\n\n"
      end

      protected

      def <<(data)
        return close! if out.closed?
        out << data
      end

      # Only keep streams alive for so long
      def keepalive_timeout?
        @keepalive_count ||= 0
        @keepalive_count += 1
        @keepalive_count > 10
      end

      def keepalive
        return close! if keepalive_timeout?
        publish(:keepalive, '')
      end

      def setup
        publish(:setup, id)
        self << "retry: 5000\n"
      end
    end
  end
end