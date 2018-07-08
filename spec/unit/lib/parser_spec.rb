require 'spec_helper'

RSpec.describe Parser do
  CHECK_AUTHENTICATION  = 1
  PUBLISH               = 2
  REMOVE_AUTHENTICATION = 3
  SET_AUTHENTICATION    = 4
  EVENT                 = 5
  ACKNOWLEDGEMENT       = 6

  describe 'parser'
  describe 'parse'
  context 'check authentication' do
    let(:event) { '' }
    let(:response_id) { 1 }

    it 'should check if client is authenticated' do
      result = Parser.parse(event, response_id)
      expect(result).to eq(CHECK_AUTHENTICATION)
    end
  end

  context 'publish' do
    let(:event) { '#publish' }
    let(:response_id) { [*1..6].sample }

    it 'should check if event is publish' do
      result = Parser.parse(event, response_id)
      expect(result).to eq(PUBLISH)
    end
  end

  context 'remove authentication token' do
    let(:event) { '#removeAuthToken' }
    let(:response_id) { [*1..6].sample }

    it 'should remove authentication token' do
      result = Parser.parse(event, response_id)
      expect(result).to eq(REMOVE_AUTHENTICATION)
    end
  end

  context 'set authentication' do
    let(:event) { '#setAuthToken' }
    let(:response_id) { [*1..6].sample }

    it 'should set authentication token' do
      result = Parser.parse(event, response_id)
      expect(result).to eq(SET_AUTHENTICATION)
    end
  end

  context 'random event' do
    let(:event) { '#event' }
    let(:response_id) { [*1..6].sample }

    it 'should check if event is publish' do
      result = Parser.parse(event, response_id)
      expect(result).to eq(EVENT)
    end
  end

  context 'acknowledgment' do
    let(:event) { '' }
    let(:response_id) { 6 }

    it 'should acknowledge the event' do
      result = Parser.parse(event, response_id)
      expect(result).to eq(ACKNOWLEDGEMENT)
    end
  end
end
