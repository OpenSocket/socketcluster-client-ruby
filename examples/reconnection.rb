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
socket.set_reconnection_listener(3000, 30_000) # (reconnect_inverval, max_reconnect_interval)
socket.set_reconnection_listener(3000, 30_000, 10) # (reconnect_inverval, max_reconnect_interval, max_attempts)
socket.set_reconnection(true) # to allow reconnection, default reconnection is disabled
socket.max_attempts = 5 # set maximum attempts allowed
socket.connect
