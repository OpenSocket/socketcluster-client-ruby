require 'socketclusterclient'

on_connect = -> { puts 'on connect got called' }

on_disconnect = -> { puts 'on disconnect got called' }

on_connect_error = -> { puts 'on connect error got called' }

on_connection_timeout = -> {puts 'connection timeout happened'}

on_connection_dropped = -> {puts 'connection dropped from existing sockets'}

on_connection_encrypted = -> {puts 'Connection is encrypted from server, check the encryption key received'}

on_connection_status_changed = -> {put 'Connection status has changed'}

ack_subscribe = lambda do |channel, error, _object|
  puts "Subscribed successfully to channel => #{channel}" if error == ''
end

ack_publish = lambda do |channel, error, _object|
  puts "Publish sent successfully to channel => #{channel}" if error == ''
end

channel_message = lambda do |key, object|
  puts "Got data => #{object} from key => #{key}"
end

ack_unsubscribe = lambda do |channel, error, _object|
  puts "Unsubscribed to channel => #{channel}" if error == ''
end

on_set_authentication = lambda do |socket, token|
  puts "Token received #{token}"
  socket.set_auth_token(token)
end

on_authentication = lambda do |socket, is_authenticated|
  puts "Authenticated is #{is_authenticated}"

  # channel communication
  socket.subscribe('yell')
  socket.publish('yell', 'Hi')
  socket.onchannel('yell', channel_message)
  socket.unsubscribe('yell')

  # channel communication with acknowledgment
  socket.subscribeack('yell', ack_subscribe)
  socket.publishack('yell', 'Hi dudies', ack_publish)
  socket.onchannel('yell', channel_message)
  socket.unsubscribeack('yell', ack_unsubscribe)
end

socket = ScClient.new('ws://localhost:8000/socketcluster/')
socket.set_basic_listener(on_connect, on_disconnect, on_connect_error)
socket.set_authentication_listener(on_set_authentication, on_authentication)
socket.connect


