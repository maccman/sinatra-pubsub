require 'sinatra/pubsub/version'

module Sinatra
  module PubSub
    autoload :Stream, 'sinatra/pubsub/stream'
    autoload :Redis, 'sinatra/pubsub/redis'
    autoload :App, 'sinatra/pubsub/app'
    autoload :Helpers, 'sinatra/pubsub/helpers'

    extend Helpers

    def self.registered(app)
      app.use App
      app.helpers Helpers
      subscribe if app.run?
    end

    def self.set(*args)
      App.set(*args)
    end
  end
end
