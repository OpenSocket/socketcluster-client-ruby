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
          expect(@socket.instance_variable_get(:@enable_reconnection)).to eq(true)
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
  end
end
