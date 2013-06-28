module Sinatra
  module PubSub
    class Hijack
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        unless env['rack.hijack?']
          return app.call(env)
        end

        status, headers, body = app.call(env)

        unless body.respond_to?(:close)
          return [status, headers, body]
        end

        headers['rack.hijack'] = lambda do |io|
          body.each do |part|
            io.write(part)
            io.flush
          end

          while !io.closed?
            sleep 1
          end
        end

        [status, headers, []]
      end
    end
  end
end