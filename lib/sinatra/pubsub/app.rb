module Sinatra
  module PubSub
    class App < Sinatra::Base
      get '/subscribe/?:channel?', :provides => 'text/event-stream' do
        error 402 unless Stream.enabled?

        stream :keep_open do |out|
          stream = Stream.new(out)

          if params[:channel]
            stream.subscribe(params[:channel])
          end

          out.callback { stream.close! }
          out.errback {  stream.close! }
        end
      end
    end
  end
end