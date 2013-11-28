require 'rubygems'
require 'bundler'

Bundler.require

require 'sinatra'
require 'sinatra/pubsub'

register Sinatra::PubSub

Sinatra::PubSub.set(
  cors:   true,
  origin: '*'
)