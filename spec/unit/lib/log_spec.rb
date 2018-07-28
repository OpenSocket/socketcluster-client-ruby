require 'spec_helper'

RSpec.describe Log do
  include Log

  describe 'log' do
    before(:each) do
      @connect_url = 'ws://localhost:8000/socketcluster/'
      @socket = ScClient.new(@connect_url)
    end

    context 'initialize_logger' do
      it 'should initialize instance variables' do
        initialize_logger
        expect(@logger).to_not eq(nil)
      end
    end

    context 'logger' do
      before(:each) do
        initialize_logger
      end

      it 'should not return nil' do
        expect(@socket.enable_logging).to_not eq(nil)
      end

      it 'should return logger class instance variable' do
        expect(@socket.logger.class).to eq(Logger)
      end
    end

    context 'logger' do
      before(:each) do
        initialize_logger
      end

      it 'should disable logging and set logger to nil' do
        expect(@socket.disable_logging).to eq(nil)
      end
    end

    context 'logger' do
      before(:each) do
        initialize_logger
      end

      it 'should not return nil' do
        expect(@socket.enable_logging).to_not eq(nil)
      end

      it 'should return logger class instance variable' do
        expect(@socket.enable_logging.class).to eq(Logger)
      end
    end
  end
end
