require 'spec_helper'

RSpec.describe Socketclusterclient do
  include Socketclusterclient

  describe 'socketcluster client' do
    before(:each) do
      @connect_url = 'ws://localhost:8000/socketcluster/'
      @socket = ScClient.new(@connect_url)
    end

    describe 'initialize' do
      context 'instance variables' do
        it 'should initialize all instance variables' do
          expect(@socket.instance_variable_get(:@id)).to eq('')
          expect(@socket.instance_variable_get(:@cnt)).to eq(0)
          expect(@socket.instance_variable_get(:@acks)).to eq({})
          expect(@socket.instance_variable_get(:@channels)).to eq([])
          expect(@socket.instance_variable_get(:@enable_reconnection)).to eq(false)
          expect(@socket.instance_variable_get(:@delay)).to eq(3)
        end

        it 'should assign connect_url to instance variable @url' do
          expect(@socket.instance_variable_get(:@url)).to eq(@connect_url)
        end
      end
    end

    describe 'set_basic_listener' do
      let(:on_connect) { -> { puts 'on connect got called' } }
      let(:on_disconnect) { -> { puts 'on connect got called' } }
      let(:on_connect_error) { -> { puts 'on connect got called' } }

      before(:each) do
        @socket.set_basic_listener(on_connect, on_disconnect, on_connect_error)
      end

      context 'set connect, disconnect and error listeners' do
        it 'should have on_connected, on_disconnected and on_connect_error listeners' do
          expect(@socket.instance_variable_get(:@on_connected)).to eq(on_connect)
          expect(@socket.instance_variable_get(:@on_disconnected)).to eq(on_disconnect)
          expect(@socket.instance_variable_get(:@on_connect_error)).to eq(on_connect_error)
        end
      end
    end

    describe 'set_authentication_listener' do
      let(:on_set_authentication) { ->(_socket, token) { @socket.set_auth_token(token) } }
      let(:on_authentication) { ->(_socket, is_authenticated) { puts "Authenticated is #{is_authenticated}" } }

      before(:each) do
        @socket.set_authentication_listener(on_set_authentication, on_authentication)
      end

      context 'set on_set_authentication and on_authentication listeners' do
        it 'should have on_set_authentication and on_authentication listeners' do
          expect(@socket.instance_variable_get(:@on_set_authentication)).to eq(on_set_authentication)
          expect(@socket.instance_variable_get(:@on_authentication)).to eq(on_authentication)
        end
      end
    end

    describe 'set_auth_token' do
      let(:token) { 1_234_567_890 }

      before(:each) do
        @socket.set_auth_token(token)
      end

      context 'set authentication token' do
        it 'should have authentication token' do
          expect(@socket.instance_variable_get(:@auth_token)).to eq(token.to_s)
        end
      end
    end

    describe 'subscribed_channels' do
      let(:channels) { %w[channel1 channel2] }

      before(:each) do
        @socket.instance_variable_set(:@channels, channels)
      end

      context 'should provide subscribed channels' do
        it 'should provide list of all subscribed channels' do
          expect(@socket.subscribed_channels).to eq(channels)
        end
      end
    end

    describe 'set_delay' do
      let(:delay) { 5 }

      before(:each) do
        @socket.set_delay(delay)
      end

      context 'should set delay' do
        it 'should set delay to assigned value' do
          expect(@socket.instance_variable_get(:@delay)).to eq(delay)
        end
      end
    end

    describe 'set_reconnection' do
      let(:reconnect) { true }

      before(:each) do
        @socket.set_reconnection(reconnect)
      end

      context 'should set reconnection strategy' do
        it 'should set to enable reconnection to assigned value' do
          expect(@socket.instance_variable_get(:@enable_reconnection)).to eq(reconnect)
        end
      end
    end

    describe 'subscribe_channels' do
      let(:channels) { %w[channel1 channel2] }

      before(:each) do
        @socket.instance_variable_set(:@channels, channels)
        @socket.set_reconnection(false)
        on_set_authentication = lambda do |socket, token|
        end
        on_authentication = lambda do |socket, _is_authenticated|
          socket.subscribe_channels
          socket.disconnect
        end
        @socket.set_authentication_listener(on_set_authentication, on_authentication)
        @socket.connect
      end

      context 'should subscribes all the channels present as instance variable of socket instance' do
        it 'should provide list of all subscribed channels' do
          expect(@socket.subscribed_channels).to eq(channels)
        end
      end
    end

    describe 'ack_block' do
      before(:each) do
        on_set_authentication = lambda do |socket, token|
        end
        on_authentication = lambda do |socket, _is_authenticated|
          @ack_block = socket.ack_block(3)
          socket.disconnect
        end
        @socket.set_authentication_listener(on_set_authentication, on_authentication)
        @socket.set_reconnection(false)
        @socket.connect
      end

      context 'should return Acknowledment block to be executed on event' do
        it 'should be a proc' do
          expect(@ack_block.is_a?(Proc)).to eq(true)
        end
      end
    end

    describe 'connect' do
      before(:each) do
        on_set_authentication = lambda do |socket, token|
        end

        on_authentication = lambda do |socket, is_authenticated|
          puts "Authenticated is #{is_authenticated}"
          socket.disconnect
        end
        @socket.set_authentication_listener(on_set_authentication, on_authentication)
      end

      it 'automatically reconnects to socketcluster server if enable_reconnection is true' do
        @socket.set_reconnection(true)
        @socket.connect
      end
    end

    describe 'disconnect' do
      before(:each) do
        @socket.set_reconnection(false)
        on_set_authentication = lambda do |socket, token|
        end
        on_authentication = lambda do |socket, is_authenticated|
          puts "Authenticated is #{is_authenticated}"
          socket.disconnect
        end
        @socket.set_authentication_listener(on_set_authentication, on_authentication)
        @socket.connect
      end

      context 'should change value of enable_reconnection and ws instance variable of socket instance' do
        it 'should set value of enable_reconnection to false' do
          expect(@socket.instance_variable_get(:@enable_reconnection)).to eq(false)
        end

        it 'should close the websocket instance' do
          expect(@socket.instance_variable_get(:@ws)).to respond_to(:close)
        end
      end
    end

    describe 'emit' do
      before(:each) do
        @socket.set_reconnection(false)
        on_set_authentication = lambda do |socket, token|
        end
        on_authentication = lambda do |socket, _is_authenticated|
          socket.emit('chat', 'Hi')
          socket.disconnect
        end
        @socket.set_authentication_listener(on_set_authentication, on_authentication)
        @socket.connect
      end

      context 'should send the data to emitted by websocket' do
        it 'should call send method of websocket instance' do
          expect(@socket.instance_variable_get(:@ws)).to respond_to(:send)
        end
      end
    end

    describe 'emit_ack' do
      before(:each) do
        @socket.set_reconnection(false)
        @ack_emit = lambda do |key, error, object|
        end
        on_set_authentication = lambda do |socket, token|
        end
        on_authentication = lambda do |socket, _is_authenticated|
          socket.emitack('chat', 'Hi', @ack_emit)
          socket.disconnect
        end
        @socket.set_authentication_listener(on_set_authentication, on_authentication)
        @socket.connect
      end

      context 'should send the data to emitted by websocket and also adds a key in acknowledment hash' do
        it 'should call send method of websocket instance' do
          expect(@socket.instance_variable_get(:@ws)).to respond_to(:send)
        end

        it 'should add a key as counter of socket instance with array as value' do
          expect(@socket.instance_variable_get(:@acks)[@socket.instance_variable_get(:@cnt)]).to eq(['chat', @ack_emit])
        end
      end
    end

    describe 'subscribeack' do
      before(:each) do
        @ack_channel = lambda do |key, error, object|
        end
        @socket.set_reconnection(false)
        on_set_authentication = lambda do |socket, token|
        end
        on_authentication = lambda do |socket, _is_authenticated|
          socket.subscribeack('channel1', @ack_channel)
          socket.disconnect
        end
        @socket.set_authentication_listener(on_set_authentication, on_authentication)
        @socket.connect
      end

      context 'should subscribe channel from channel list' do
        it 'should add channel from instance variable channel' do
          expect(@socket.instance_variable_get(:@channels)).to eq(['channel1'])
        end

        it 'should add a key as counter of socket instance with array as value' do
          expect(@socket.instance_variable_get(:@acks)[@socket.instance_variable_get(:@cnt) - 1]).to eq(['channel1', @ack_channel])
        end
      end
    end

    describe 'unsubscribe' do
      let(:channels) { %w[channel1 channel2] }
      before(:each) do
        @socket.instance_variable_set(:@channels, channels)
        @socket.set_reconnection(false)
        on_set_authentication = lambda do |socket, token|
        end
        on_authentication = lambda do |socket, _is_authenticated|
          socket.unsubscribe('channel1')
          socket.disconnect
        end
        @socket.set_authentication_listener(on_set_authentication, on_authentication)
        @socket.connect
      end

      context 'should unsubscribe channel from channel list' do
        it 'should remove channel from instance variable channel' do
          expect(@socket.instance_variable_get(:@channels)).to eq(['channel2'])
        end
      end
    end

    describe 'unsubscribeack' do
      let(:channels) { %w[channel1 channel2] }

      before(:each) do
        @ack_channel = lambda do |key, error, object|
        end
        @socket.instance_variable_set(:@channels, channels)
        @socket.set_reconnection(false)
        on_set_authentication = lambda do |socket, token|
        end
        on_authentication = lambda do |socket, _is_authenticated|
          socket.unsubscribeack('channel1', @ack_channel)
          socket.disconnect
        end
        @socket.set_authentication_listener(on_set_authentication, on_authentication)
        @socket.connect
      end

      context 'should unsubscribe channel from channel list' do
        it 'should remove channel from instance variable channel' do
          expect(@socket.instance_variable_get(:@channels)).to eq(['channel2'])
        end

        it 'should add a key as counter of socket instance with array as value' do
          expect(@socket.instance_variable_get(:@acks)[@socket.instance_variable_get(:@cnt) - 1]).to eq(['channel1', @ack_channel])
        end
      end
    end

    describe 'publish' do
      let(:channels) { %w[channel1] }
      before(:each) do
        @socket.instance_variable_set(:@channels, channels)
        @socket.set_reconnection(false)
        on_set_authentication = lambda do |socket, token|
        end
        on_authentication = lambda do |socket, _is_authenticated|
          socket.subscribe('channel1')
          socket.publish('channel1', 'hi')
          socket.disconnect
        end
        @socket.set_authentication_listener(on_set_authentication, on_authentication)
        @socket.connect
      end

      context 'should publish message on the specified channel' do
        it 'should call send method of websocket instance' do
          expect(@socket.instance_variable_get(:@ws)).to respond_to(:send)
        end
      end
    end

    describe 'publishack' do
      let(:channels) { %w[channel1] }
      before(:each) do
        @ack_publish = lambda do |key, error, object|
        end
        @socket.instance_variable_set(:@channels, channels)
        @socket.set_reconnection(false)
        on_set_authentication = lambda do |socket, token|
        end
        on_authentication = lambda do |socket, _is_authenticated|
          socket.subscribe('channel1')
          socket.publishack('channel1', 'hi', @ack_publish)
          socket.disconnect
        end
        @socket.set_authentication_listener(on_set_authentication, on_authentication)
        @socket.connect
      end

      context 'should publish message on the specified channel' do
        it 'should call send method of websocket instance' do
          expect(@socket.instance_variable_get(:@ws)).to respond_to(:send)
        end

        it 'should add a key as counter of socket instance with array as value' do
          expect(@socket.instance_variable_get(:@acks)[@socket.instance_variable_get(:@cnt) - 1]).to eq(['channel1', @ack_publish])
        end
      end
    end

    describe 'logger' do
      before(:each) do
        @logger = @socket.logger
      end

      it 'returns a logger object' do
        expect(@logger.class).to eq(Logger)
      end
    end

    describe 'disable_logging' do
      before(:each) do
        @socket.disable_logging
      end

      it 'sets logger object to nil' do
        expect(@socket.instance_variable_get(:@logger)).to eq(nil)
      end
    end

    describe 'reset_value' do
      before(:each) do
        @socket.send(:reset_value)
      end

      context 'should reset counter value' do
        it 'should set counter value to 0' do
          expect(@socket.instance_variable_get(:@cnt)).to eq(0)
        end
      end
    end

    describe 'increment_cnt' do
      context 'should increment counter' do
        it 'should increment counter value by 1' do
          expect { @socket.send(:increment_cnt) }.to change { @socket.instance_variable_get(:@cnt) }.by(1)
        end
      end
    end
  end
end
