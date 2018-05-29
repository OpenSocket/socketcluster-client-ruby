require 'socketclusterclient'

on_connect = -> { puts 'on connect got called' }

on_disconnect = -> { puts 'on disconnect got called' }

on_connect_error = -> { puts 'on connect error got called' }

on_set_authentication = lambda do |socket, token|
  puts "Token received #{token}"
  socket.set_auth_token(token)
end

on_authentication = lambda do |_socket, is_authenticated|
  puts "Authenticated is #{is_authenticated}"
end

socket = ScClient.new('ws://localhost:8000/socketcluster/')
socket.set_basic_listener(on_connect, on_disconnect, on_connect_error)
socket.set_authentication_listener(on_set_authentication, on_authentication)
socket.set_reconnection(true) # default reconnection is true
socket.set_delay(5) # reconnect in 5 seconds
socket.connect
