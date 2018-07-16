require 'spec_helper'

RSpec.describe Reconnect do
  include Reconnect

  describe 'reconnect' do
    before(:each) do
      @connect_url = 'ws://localhost:8000/socketcluster/'
      @socket = ScClient.new(@connect_url)
    end

    context 'initialize_reconnect' do
      it 'should initialize instance variables' do
        initialize_reconnect
        expect(@reconnect_interval).to eq(2000)
        expect(@max_reconnect_interval).to eq(30_000)
        expect(@reconnect_decay).to eq(1)
        expect(@max_attempts).to eq(nil)
        expect(@attempts_made).to eq(0)
      end
    end

    context 'set_reconnection_listener' do
      before(:each) do
        set_reconnection_listener(3000, 21_000, 1, 10)
      end

      it 'should assign values to instance variables related to reconnection strategy' do
        expect(@reconnect_interval).to eq(3000)
        expect(@max_reconnect_interval).to eq(21_000)
        expect(@reconnect_decay).to eq(1)
        expect(@max_attempts).to eq(10)
      end
    end

    context 'reconnect' do
      before(:each) do
        initialize_reconnect
        @socket.max_attempts = 5
        on_set_authentication = lambda do |socket, token|
        end
        on_authentication = lambda do |socket, _is_authenticated|
          socket.disconnect
        end
        @socket.set_authentication_listener(on_set_authentication, on_authentication)
        @socket.set_reconnection(false)
        @socket.reconnect
      end

      it 'sets attempts_made to 0 after completion' do
        expect(@socket.instance_variable_get(:@attempts_made)).to eq(0)
      end
    end

    context 'reconnection_attempts_finished' do
      it 'returns true if attempts_made is greater than equal to max_attempts' do
        @socket.instance_variable_set(:@max_attempts , 10)
        @socket.instance_variable_set(:@attempts_made, 10)
        expect(@socket.send(:reconnection_attempts_finished)).to eq(true)
      end

      it 'returns false if attempts_made is less than max_attempts' do
        @socket.instance_variable_set(:@max_attempts , 10)
        @socket.instance_variable_set(:@attempts_made, 9)
        expect(@socket.send(:reconnection_attempts_finished)).to eq(false)
      end
    end
  end
end
