require 'sinatra/pubsub/version'

module Sinatra
  module PubSub
    autoload :Hijack, 'sinatra/pubsub/hijack'
    autoload :Stream, 'sinatra/pubsub/stream'
    autoload :Redis, 'sinatra/pubsub/redis'
    autoload :App, 'sinatra/pubsub/app'
    autoload :Helpers, 'sinatra/pubsub/helpers'

    extend Helpers

    def self.registered(app)
      app.use App
      app.helpers Helpers
      subscribe
    end
  end
end
