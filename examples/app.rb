require 'sinatra'
require 'sinatra/pubsub'

register Sinatra::PubSub

Sinatra::PubSub.set(cors: true)

EventMachine.next_tick do
  EventMachine::PeriodicTimer.new(1) do
    Sinatra::PubSub.publish_all(type: 'tick')
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
  var es = new EventSource('/subscribe');
  es.onmessage = function(e) { log.innerHTML += "\n" + e.data };
</script>