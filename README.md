# Sinatra::PubSub

PubSub is a little extension to Sinatra that adds basic publish/subscribe streaming
using HTML5 Server Sent Events.

For example, clients can subscribe to events like this:

    var es = new EventSource('/subscribe');
    es.onmessage = function(e) {
      console.log(JSON.parse(e.data));
    };

And then you can broadcast events to them like this:

    Sinatra::PubSub.publish_all(type: 'tick')

You can subscribe to specific channels:

    var es = new EventSource('/subscribe/sites/123');

And publish to them:

    Sinatra::PubSub.publish('sites/123', data: 'hi')

## Requirements

* Thin
* Redis
* Sinatra

## Installation

Add this line to your application's Gemfile:

    gem 'sinatra-pubsub'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sinatra-pubsub

## Usage

Include it in your Sinatra application like so:

    require 'sinatra/pubsub'
    register Sinatra::PubSub

This creates a `/subscribe/*` endpoint, which clients can use with `EventSource`.

You can publish to channels using the `Sinatra::PubSub.publish_all(msg)` or
`Sinatra::publish(channel, msg)` methods.

Messages will be automatically serialized to JSON - you'll need to parse them on the client.
See the `./examples` dir for more use-cases.

## Herkou 123

It's often a good idea to create a separate streaming server on a subdomain, rather than
using your main application server for streaming. This gives you a bit more flexibility, like
letting you use a Unicorn for your application server, and Thin for your streaming server.
This is a quick guide to creating exactly that on Heroku.

First create your streaming server from the 'basic' example.

    git clone https://github.com/maccman/sinatra-pubsub.git
    cp -r sinatra-pubsub/examples/basic myapp-stream
    cd myapp-stream
    bundle install
    git init
    git add .
    git commit -m 'first commit'
    heroku create myapp-stream
    git push heroku master

Now the server is deployed, you need to setup Redis. If you already have Redis running
on your main application server, just run:

    heroku config -a myapp-stream | grep REDIS
    heroku config:set REDIS_URL=YOUR_REDIS_URL -a myapp-stream

Otherwise install the Redis To Go addon:

    heroku addons:add rediscloud -a myapp-stream
    heroku config -a myapp-stream | grep REDIS
    heroku config:set REDIS_URL=YOUR_REDIS_URL -a myapp-stream

And you're finished! You can subscribe to a channel from any browser like this:

    var es = new EventSource('http://myapp-stream.herokuapp.com/subscribe');
    es.onmessage = function(e) {
      console.log(JSON.parse(e.data));
    };

And publish to the stream from any Ruby client connected to the same Redis server:

    Sinatra::PubSub.publish_all('Hello World')
