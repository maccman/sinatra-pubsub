require 'rubygems'
require 'bundler'

Bundler.require

register Sinatra::PubSub

Sinatra::PubSub.set(
  cors: false
)

EventMachine.next_tick do
  EventMachine::PeriodicTimer.new(1) do
    Sinatra::PubSub.publish('tick', type: 'tick')
  end
end

get '/' do
  erb :stream
end

__END__

@@ stream
<pre id="log">
</pre>

<script>
  // reading
  var es = new EventSource('/subscribe/tick');
  es.onmessage = function(e) { log.innerHTML += "\n" + e.data };
</script>