require 'sinatra'
require 'sinatra/pubsub'

register Sinatra::PubSub

Sinatra::PubSub.set(
  cors:   true,
  origin: '*'
)