# socketcluster-client-ruby
A Ruby client for socketcluster.io

Refer examples for more details :

Overview
--------
This client provides following functionality

- Easy to setup and use
- Support for emitting and listening to remote events
- Automatic reconnection
- Pub/sub
- Authentication (JWT)
- Can be used for extensive unit-testing of all server side functions
- Support for ruby >= 2.2.0

To install use
```ruby
    gem install socketclusterclient
```

Description
-----------
Create instance of `Socket` class by passing url of socketcluster-server end-point

```ruby
    # Create a socket instance
    socket = ScClient.new('ws://localhost:8000/socketcluster/')
```
**Important Note** : Default url to socketcluster end-point is always *ws://somedomainname.com/socketcluster/*.

#### Registering basic listeners

- Different functions are given as an argument to register listeners

```ruby
    require 'socketclusterclient'
    require 'logger'

    logger = Logger.new(STDOUT)
    logger.level = Logger::WARN

    on_connect = -> { logger.info('on connect got called') }

    on_disconnect = -> { logger.info('on disconnect got called') }

    on_connect_error = -> { logger.info('on connect error got called') }

    on_set_authentication = lambda do |socket, token|
      logger.info("Token received #{token}")
      socket.set_auth_token(token)
    end

    on_authentication = lambda do |socket, is_authenticated|
      logger.info("Authenticated is #{is_authenticated}")
    end

    socket = ScClient.new('ws://localhost:8000/socketcluster/')
    socket.set_basic_listener(on_connect, on_disconnect, on_connect_error)
    socket.set_authentication_listener(on_set_authentication, on_authentication)
    socket.connect
```

#### Connecting to server

- For connecting to server

```ruby
    # This will send websocket handshake request to socketcluster-server
    socket.connect
```

- By default reconnection to server is enabled, to configure delay for connection

```ruby
    # This will set automatic-reconnection to server with delay of 2 seconds and repeat it infinitely
    socket.set_delay(2)
    socket.connect
```

- To disable reconnection

```ruby
    # To disable reconnection
    socket.set_reconnection(false)
```

Emitting and listening to events
--------------------------------

#### Event emitter

- To emit a specified event on the corresponding socketcluster-server. The object sent can be String, Boolean, Long or JSONObject.

```ruby
    # Emit an event
    socket.emit(event_name, message);

    socket.emit("chat", "Hi")
```

- To emit a specified event with acknowledgement on the corresponding socketcluster-server. The object sent can be String, Boolean, Long or JSONObject.

```ruby
    # Emit an event with acknowledgment
    socket.emitack(event_name, message, ack_emit)

    socket.emitack('chat', 'Hello', ack_emit)

    ack_emit = lambda do |key, error, object|
      puts "Got ack data => #{object} and error => #{error} and key => #{key}"
    end
```

#### Event Listener

- To listen an event from the corresponding socketcluster-server. The object received can be String, Boolean, Long or JSONObject.

```ruby
    # Receive an event
    socket.on(event, message)

    socket.on('ping', message)

    message = lambda do |key, object|
      puts "Got data => #{object} from key => #{key}"
    end
```

- To listen an event from the corresponding socketcluster-server and send the acknowledgment back. The object received can be String, Boolean, Long or JSONObject.

```ruby
    # Receive an event and send the acknowledgement back
    socket.onack(event, message_with_acknowledgment)

    socket.onack('ping', ack_message)

    ack_message = lambda do |key, object, block_ack_message|
      puts "Got ack data => #{object} from key => #{key}"
      block_ack_message.call('error lorem', 'data ipsum')
    end
```

Implementing Pub-Sub via channels
---------------------------------

#### Creating channel

- For creating and subscribing to channels:

```ruby
    # Subscribe to a channel
    socket.subscribe('yell')

    # Subscribe to a channel with acknowledgement
    socket.subscribeack('yell', ack_subscribe)

    ack_subscribe = lambda do |channel, error, _object|
      puts "Subscribed successfully to channel => #{channel}" if error == ''
    end
```

- For getting list of created channels :

```ruby
    # Get all subscribed channel
    channels = socket.get_subscribed_channels
```

#### Publishing event on channel

- For publishing event :

```ruby
    # Publish to a channel
    socket.publish('yell', 'Hi')

    # Publish to a channel with acknowledgment
    socket.publishack('yell', 'Hi', ack_publish)

    ack_publish = lambda do |channel, error, _object|
      puts "Publish sent successfully to channel => #{channel}" if error == ''
    end
```

#### Listening to channel

- For listening to channel event :

```ruby
    # Listen to a channel
    socket.onchannel('yell', channel_message)

    channel_message = lambda do |key, object|
      puts "Got data => #{object} from key => #{key}"
    end
```

#### Un-subscribing to channel

- For unsubscribing to a channel

```ruby
    # Unsubscribe to a channel
    socket.unsubscribe('yell')

    # Unsubscribe to a channel with acknowledgement
    socket.unsubscribeack('yell', ack_unsubscribe)

    ack_unsubscribe = lambda do |channel, error, _object|
      puts "Unsubscribed to channel => #{channel}" if error == ''
    end
```
