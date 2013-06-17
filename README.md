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

    Sinatra::PubSub.publish_all('sites/123', data: 'hi')

## Requirements

* An evented server, such as Thin
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
