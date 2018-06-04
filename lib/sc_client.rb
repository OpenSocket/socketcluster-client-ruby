require 'websocket-eventmachine-client'
require 'json'

require_relative './socketclusterclient/emitter'
require_relative './socketclusterclient/parser'
require_relative './socketclusterclient/data_models'

#
# Class ScClient provides an interface to connect to the socketcluster server
#
# @author Maanav Shah <shahmaanav07@gmail.com>
#
class ScClient
  include Emitter
  include DataModels

  #
  # Initializes instance variables in socketcluster client
  #
  # @param [String] url ScServer connection URL
  #
  def initialize(url)
    @id = ''
    @cnt = 0
    @url = url
    @acks = {}
    @channels = []
    @enable_reconnection = true
    @delay = 3
    initialize_emitter
  end

  #
  # Adds handler for connect, disconnect and error
  #
  # @param [Lambda] on_connected Block to execute on connected
  # @param [Lambda] on_disconnected Block to execute on disconnected
  # @param [Lambda] on_connect_error Block to execute on connection error
  #
  #
  #
  def set_basic_listener(on_connected, on_disconnected, on_connect_error)
    @on_connected = on_connected
    @on_disconnected = on_disconnected
    @on_connect_error = on_connect_error
  end

  #
  # Adds handler for authentication
  #
  # @param [Lambda] on_set_authentication Block to set authentication token
  # @param [Lambda] on_authentication Block to execute on authentication
  #
  #
  #
  def set_authentication_listener(on_set_authentication, on_authentication)
    @on_set_authentication = on_set_authentication
    @on_authentication = on_authentication
  end

  #
  # Method to set the authentication token
  #
  # @param [String] token Authentication token provided by ScServer
  #
  #
  #
  def set_auth_token(token)
    @auth_token = token.to_s
  end

  #
  # Get the list of all subscribed channels
  #
  #
  #
  #
  def get_subscribed_channels
    @channels
  end

  #
  # Subscribe all the channels available
  #
  #
  #
  #
  def subscribe_channels
    @channels.each { |channel| subscribe(channel) }
  end

  #
  # Acknowledment block to be executed on event
  #
  # @param [String] cid @cnt id received from ScServer
  #
  # @return [Lambda] Acknowledgment to be sent to ScServer
  #
  def ack_block(cid)
    ws = @ws
    lambda do |error, data|
      ws.send(get_ack_object(error, data, cid))
    end
  end

  #
  # Connect to the ScServer
  #
  #
  #
  #
  def connect
    EM.epoll

    EM.run do
      trap('TERM') { stop }
      trap('INT')  { stop }
      @ws = WebSocket::EventMachine::Client.connect(uri: @url)

      @ws.onopen do
        reset_value
        @ws.send(get_handshake_object(increment_cnt).to_json)
        @on_connected.call if @on_connected
      end

      @ws.onmessage do |message, _type|
        if message == '#1'
          @ws.send('#2')
        else
          main_object = JSON.parse(message)
          data_object = main_object['data']
          rid = main_object['rid']
          cid = main_object['cid']
          event = main_object['event']
          result = Parser.parse(event, rid)
          if result == Parser::CHECK_AUTHENTICATION
            if @on_authentication
              @id = data_object['id']
              @on_authentication.call(self, data_object['isAuthenticated'])
            end
            subscribe_channels
          elsif result == Parser::PUBLISH
            execute(data_object['channel'], data_object['data'])
          elsif result == Parser::REMOVE_AUTHENTICATION
            @auth_token = nil
          elsif result == Parser::SET_AUTHENTICATION
            if @on_set_authentication
              @on_set_authentication.call(self, data_object['token'])
            end
          elsif result == Parser::EVENT
            if haseventack(event)
              executeack(event, data_object, ack_block(cid))
            else
              execute(event, data_object)
            end
          else # Parser::ACKNOWLEDGEMENT
            tuple = @acks[rid] if @acks.include?(rid)
            if tuple
              ack = tuple[1]
              ack.call(tuple[0], String(main_object['error']), String(main_object['data']))
            end
          end
        end
      end

      @ws.onerror do |error|
        @on_connect_error.call(error) if @on_connect_error
      end

      @ws.onclose do
        @on_disconnected.call if @on_disconnected
        if @enable_reconnection
          reconnect
        else
          stop
        end
      end

      def stop
        EventMachine.stop
      end
    end
  end

  #
  # Set the delay for reconnection to ScServer
  #
  # @param [Integer] delay Delay in seconds to reconnect
  #
  #
  #
  def set_delay(delay)
    @delay = delay
  end

  #
  # Allows to reconnect to ScServer
  #
  # @param [Boolean] enable True to reconnect to server, False to disconnect
  #
  #
  #
  def set_reconnection(enable)
    @enable_reconnection = enable
  end

  #
  # Disconnects the connection with ScServer
  #
  #
  #
  #
  def disconnect
    @enable_reconnection = false
    @ws.close
  end

  #
  # Emits the specified event on the corresponding server-side socket
  #
  # @param [String] event Event
  # @param [String] object Data for the specified event
  #
  #
  #
  def emit(event, object)
    @ws.send(get_emit_object(event, object).to_json)
  end

  #
  # Emits the specified event on the corresponding server-side socket with acknowledgment
  #
  # @param [String] event Event
  # @param [String] object Data for the specified event
  # @param [Lambda] ack Block to execute on event acknowledgment
  #
  # @return [<type>] <description>
  #
  def emitack(event, object, ack)
    @ws.send(get_emit_ack_object(event, object, increment_cnt).to_json)
    @acks[@cnt] = [event, ack]
  end

  #
  # Subscribes to a particular channel
  #
  # @param [String] channel A channel name
  #
  #
  #
  def subscribe(channel)
    @ws.send(get_subscribe_object(channel, increment_cnt).to_json)
    @channels << channel unless @channels.include?(channel)
  end

  #
  # Subscribes to a particular channel with acknowledgment
  #
  # @param [String] channel A channel name
  # @param [Lambda] ack Block to execute on subscribe acknowledgment
  #
  #
  #
  def subscribeack(channel, ack)
    @ws.send(get_subscribe_object(channel, increment_cnt).to_json)
    @channels << channel
    @acks[@cnt] = [channel, ack]
  end

  #
  # Unsubscribes to a particular channel
  #
  # @param [String] channel A channel name
  #
  #
  #
  def unsubscribe(channel)
    @ws.send(get_unsubscribe_object(channel, increment_cnt).to_json)
    @channels.delete(channel)
  end

  #
  # Unsubscribes to a particular channel with acknowledgment
  #
  # @param [String] channel A channel name
  # @param [Lambda] ack Block to execute on unsubscribe acknowledgment
  #
  #
  #
  def unsubscribeack(channel, ack)
    @ws.send(get_unsubscribe_object(channel, increment_cnt).to_json)
    @channels.delete(channel)
    @acks[@cnt] = [channel, ack]
  end

  #
  # Publish data to the specified channel name
  #
  # @param [String] channel A channel name
  # @param [String] data Data to be published on the channel
  #
  #
  #
  def publish(channel, data)
    @ws.send(get_publisher_object(channel, data, increment_cnt).to_json)
  end

  #
  #  Publish data to the specified channel name
  #
  # @param [String] channel A channel name
  # @param [String] data Data to be published on the channel
  # @param [Lambda] ack Block to execute on publish acknowledgment
  #
  # @return [<type>] <description>
  #
  def publishack(channel, data, ack)
    @ws.send(get_publisher_object(channel, data, increment_cnt).to_json)
    @acks[@cnt] = [channel, ack]
  end

  private

  #
  # Resets the value of @cnt
  #
  #
  #
  #
  def reset_value
    @cnt = 0
  end

  #
  # Increments the value of @cnt
  #
  #
  #
  #
  def increment_cnt
    @cnt += 1
  end

  #
  # Reconnects to ScServer after delay
  #
  #
  #
  #
  def reconnect
    sleep @delay
    connect
  end
end
