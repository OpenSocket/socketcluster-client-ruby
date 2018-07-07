require 'spec_helper'

RSpec.describe DataModels do
  include DataModels

  describe 'data_models' do
    context 'get_ack_object' do
      let(:error) { 'error' }
      let(:data) { { key: 'value' } }
      let(:cid) { [*1..6].sample }

      before(:each) do
        @ack_object = get_ack_object(error, data, cid)
      end

      it 'should return an ack object of type hash' do
        expect(@ack_object.class).to eq(Hash)
      end

      it 'should return an error, data and cid in ack object' do
        expect(@ack_object.keys.include?(:error)).to be(true)
        expect(@ack_object[:error]).to eq(error)
        expect(@ack_object.keys.include?(:data)).to be(true)
        expect(@ack_object[:data]).to eq(data)
        expect(@ack_object.keys.include?(:cid)).to be(true)
        expect(@ack_object[:cid]).to eq(cid)
      end
    end

    context 'get_emit_object' do
      let(:event) { 'event' }
      let(:data) { { key: 'value' } }

      before(:each) do
        @emit_object = get_emit_object(event, data)
      end

      it 'should return an emit object of type hash' do
        expect(@emit_object.class).to eq(Hash)
      end

      it 'should return an event and data in emit object' do
        expect(@emit_object.keys.include?(:event)).to be(true)
        expect(@emit_object[:event]).to eq(event)
        expect(@emit_object.keys.include?(:data)).to be(true)
        expect(@emit_object[:data]).to eq(data)
      end
    end

    context 'get_emit_ack_object' do
      let(:event) { 'event' }
      let(:data) { { key: 'value' } }
      let(:cid) { [*1..6].sample }

      before(:each) do
        @emit_ack_object = get_emit_ack_object(event, data, cid)
      end

      it 'should return an emit ack object of type hash' do
        expect(@emit_ack_object.class).to eq(Hash)
      end

      it 'should return an event, data and cid in emit ack object' do
        expect(@emit_ack_object.keys.include?(:event)).to be(true)
        expect(@emit_ack_object[:event]).to eq(event)
        expect(@emit_ack_object.keys.include?(:data)).to be(true)
        expect(@emit_ack_object[:data]).to eq(data)
        expect(@emit_ack_object.keys.include?(:cid)).to be(true)
        expect(@emit_ack_object[:cid]).to eq(cid)
      end
    end

    context 'get_handshake_object' do
      let(:cid) { [*1..6].sample }

      before(:each) do
        @handshake_object = get_handshake_object(cid)
      end

      it 'should return a handshake object of type hash' do
        expect(@handshake_object.class).to eq(Hash)
      end

      it 'should return an event, data and cid in handshake object' do
        expect(@handshake_object.keys.include?(:event)).to be(true)
        expect(@handshake_object[:event]).to eq('#handshake')
        expect(@handshake_object.keys.include?(:data)).to be(true)
        expect(@handshake_object[:data].keys.include?(:authToken)).to be(true)
        expect(@handshake_object.keys.include?(:cid)).to be(true)
        expect(@handshake_object[:cid]).to eq(cid)
      end
    end

    context 'get_publish_object' do
      let(:channel) { 'channel' }
      let(:data) { { key: 'value' } }
      let(:cid) { [*1..6].sample }

      before(:each) do
        @publish_object = get_publish_object(channel, data, cid)
      end

      it 'should return a publish object of type hash' do
        expect(@publish_object.class).to eq(Hash)
      end

      it 'should return an event, channel, data and cid in publish object' do
        expect(@publish_object.keys.include?(:event)).to be(true)
        expect(@publish_object[:event]).to eq('#publish')
        expect(@publish_object.keys.include?(:data)).to be(true)
        expect(@publish_object[:data].keys.include?(:channel)).to be(true)
        expect(@publish_object[:data].class).to eq(Hash)
        expect(@publish_object.keys.include?(:cid)).to be(true)
        expect(@publish_object[:cid]).to be(cid)
      end
    end

    context 'get_subscribe_object' do
      let(:channel) { 'channel' }
      let(:cid) { [*1..6].sample }

      before(:each) do
        @subscribe_object = get_subscribe_object(channel, cid)
      end

      it 'should return a subscribe object of type hash' do
        expect(@subscribe_object.class).to eq(Hash)
      end

      it 'should return an event, data, channel and cid in subscribe object' do
        expect(@subscribe_object.keys.include?(:event)).to be(true)
        expect(@subscribe_object[:event]).to eq('#subscribe')
        expect(@subscribe_object[:data].class).to eq(Hash)
        expect(@subscribe_object.keys.include?(:data)).to be(true)
        expect(@subscribe_object[:data].keys.include?(:channel)).to be(true)
        expect(@subscribe_object[:data][:channel]).to eq(channel)
        expect(@subscribe_object.keys.include?(:cid)).to be(true)
        expect(@subscribe_object[:cid]).to be(cid)
      end
    end

    context 'get_unsubscribe_object' do
      let(:channel) { 'channel' }
      let(:cid) { [*1..6].sample }

      before(:each) do
        @unsubscribe_object = get_unsubscribe_object(channel, cid)
      end

      it 'should return an unsubscribe object of type hash' do
        expect(@unsubscribe_object.class).to eq(Hash)
      end

      it 'should return an event, data and cid in unsubscribe object' do
        expect(@unsubscribe_object.keys.include?(:event)).to be(true)
        expect(@unsubscribe_object[:event]).to eq('#unsubscribe')
        expect(@unsubscribe_object.keys.include?(:data)).to be(true)
        expect(@unsubscribe_object[:data]).to eq(channel)
        expect(@unsubscribe_object.keys.include?(:cid)).to be(true)
        expect(@unsubscribe_object[:cid]).to be(cid)
      end
    end
  end
end
