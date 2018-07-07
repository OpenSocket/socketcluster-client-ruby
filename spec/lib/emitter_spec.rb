require 'spec_helper'

RSpec.describe Emitter do
  include Emitter

  describe 'emitter' do
    context 'initialize_emitter' do
      it 'should not have instance variables' do
        expect(@events).to eq(nil)
        expect(@events_ack).to eq(nil)
      end

      it 'should initialize instance variables' do
        initialize_emitter

        expect(@events).to_not eq(nil)
        expect(@events_ack).to_not eq(nil)
        expect(@events.class).to eq(Hash)
        expect(@events_ack.class).to eq(Hash)
      end
    end

    context 'on' do
      before(:each) do
        initialize_emitter
      end

      let(:key) { 'ping' }
      let(:message) { ->(key, object) { "#{key} #{object}" } }

      it 'should not have an event with key' do
        expect(@events[key]).to eq(nil)
      end

      it 'should have an event with key' do
        on(key, message)

        expect(@events[key]).to be(message)
      end
    end

    context 'onchannel' do
      before(:each) do
        initialize_emitter
      end

      let(:key) { 'ping' }
      let(:message) { ->(key, object) { "#{key} #{object}" } }

      it 'should not have an event with key' do
        expect(@events[key]).to eq(nil)
      end

      it 'should have an event with key' do
        onchannel(key, message)

        expect(@events[key]).to be(message)
      end
    end

    context 'onack' do
      before(:each) do
        initialize_emitter
      end

      let(:key) { 'ping' }
      let(:message) { ->(key, object, ack_block) { ack_block.call(key, object) } }
      let(:ack_message) { ->(key, object) { "#{key} #{object}" } }

      it 'should not have an acknowledgement event with key' do
        expect(@events_ack[key]).to eq(nil)
      end

      it 'should have an acknowledgement event with key' do
        onack(key, ack_message)

        expect(@events_ack[key]).to be(ack_message)
      end
    end

    context 'execute' do
      before(:each) do
        initialize_emitter
      end

      let(:key) { 'ping' }
      let(:message) { ->(key, object) { "#{key} #{object}" } }

      it 'should not have an event with key' do
        expect(@events[key]).to eq(nil)
      end

      it 'should execute event' do
        on(key, message)

        expect(execute(key, 'pong')).to eq('ping pong')
      end
    end

    context 'haseventack' do
      before(:each) do
        initialize_emitter
      end

      let(:key) { 'ping' }
      let(:message) { ->(key, object) { "#{key} #{object}" } }

      it 'should not have an event with key' do
        expect(@events_ack[key]).to eq(nil)
      end

      it 'should return an acknowledgment event from key' do
        onack(key, message)

        expect(haseventack(key)).to eq(message)
      end
    end

    context 'onack' do
      before(:each) do
        initialize_emitter
      end

      let(:key) { 'ping' }
      let(:message) { ->(key, object, ack_block) { ack_block.call(key, object) } }
      let(:ack_message) { ->(key, object) { "#{key} #{object}" } }

      it 'should not have an event with key' do
        expect(@events_ack[key]).to eq(nil)
      end

      it 'should expect an acknowledgment event from key' do
        onack(key, message)

        expect(executeack(key, 'pong', ack_message)).to eq('ping pong')
      end
    end
  end
end
