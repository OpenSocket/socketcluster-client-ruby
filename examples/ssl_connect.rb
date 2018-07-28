require 'socketclusterclient'

on_connect = -> { puts 'on connect got called' }

on_disconnect = -> { puts 'on disconnect got called' }

on_connect_error = -> { puts 'on connect error got called' }

# connection to ssl server at websocket.org
socket = ScClient.new('wss://echo.websocket.org/')
socket.set_basic_listener(on_connect, on_disconnect, on_connect_error)
socket.connect
