module Sinatra
  module PubSub
    class App < Sinatra::Base
      configure do
        set :cors, false
        set :origin, '*'
      end

      helpers do
        def http_origin
          env['HTTP_ORIGIN']
        end
      end

      before do
        return unless cors

        origin = http_origin || ''
        secure = origin =~ /\Ahttps/

        allow  = settings.origin
        allow.gsub!(/\Ahttp:\/\//, 'https://') if secure

        headers['Access-Control-Allow-Origin']      = allow
        headers['Access-Control-Allow-Methods']     = 'GET'
        headers['Access-Control-Allow-Credentials'] = 'true'
      end

      get '/subscribe/?*', :provides => 'text/event-stream' do
        error 402 unless Stream.enabled?

        stream :keep_open do |out|
          stream  = Stream.new(out)

          if channels = params[:splat]
            stream.subscribe(channels.join('/'))
          end

          out.callback { stream.close! }
          out.errback {  stream.close! }
        end
      end
    end
  end
end