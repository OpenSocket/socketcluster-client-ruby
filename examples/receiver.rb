require 'socketclusterclient'

on_connect = -> { puts 'on connect got called' }

on_disconnect = -> { puts 'on disconnect got called' }

on_connect_error = -> { puts 'on connect error got called' }

message = lambda do |key, object|
  puts "Got data => #{object} from key => #{key}"
end

ack_message = lambda do |key, object, block_ack_message|
  puts "Got ack data => #{object} from key => #{key}"
  block_ack_message.call('error lorem', 'data ipsum')
end

on_set_authentication = lambda do |socket, token|
  puts "Token received #{token}"
  socket.set_auth_token(token)
end

on_authentication = lambda do |socket, is_authenticated|
  puts "Authenticated is #{is_authenticated}"

  # bind ping event on ScServer
  socket.on('yell', message)

  # bind ping event on ScServer with acknowledgment
  socket.onack('ping', ack_message)
end

socket = ScClient.new('ws://localhost:8000/socketcluster/')
socket.set_basic_listener(on_connect, on_disconnect, on_connect_error)
socket.set_authentication_listener(on_set_authentication, on_authentication)
socket.connect
