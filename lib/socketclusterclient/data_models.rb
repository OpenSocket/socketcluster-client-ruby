require 'ostruct'

# Module DataModels provides JSON format based serialized and deserialized
# objects that ensures tight coupling
# @author Piyush Wani <piyushwww13@gmail.com>
#
module DataModels
  # Returns a data model for an acknowledgment event
  #
  # @param [String] error An acknowledgment event
  # @param [String] data A data object
  # @param [Integer] cid A remote counter id
  #
  # @return An acknowledgement object
  #
  def get_ack_object(error, data, cid)
    OpenStruct.new(
      cid: cid,
      data: data,
      error: error
    ).to_h
  end

  # Returns a data model for an emitter event
  #
  # @param [String] event An emit event
  # @param [Hash] object A data object
  #
  # @return An emit object
  #
  def get_emit_object(event, object)
    OpenStruct.new(
      event: event,
      data: object
    ).to_h
  end

  # Returns a data model for an emitter acknowledgment event
  #
  # @param [String] event An emitter acknowledgment event
  # @param [Hash] object A data object
  # @param [Integer] counter A counter for a particular event
  #
  # @return An emitter acknowledgment object
  #
  def get_emit_ack_object(event, object, counter)
    OpenStruct.new(
      event: event,
      data: object,
      c_id: counter
    ).to_h
  end

  # Returns a data model for a handshake event
  #
  # @param [Integer] counter A counter for a particular event
  #
  # @return A handshake object
  #
  def get_handshake_object(counter)
    OpenStruct.new(
      cid: counter,
      data: OpenStruct.new(
        authToken: @auth_token
      ).to_h,
      event: '#handshake'
    ).to_h
  end

  # Returns a data model for publish and publish with acknowledgment event
  #
  # @param [String] channel A channel for publishing data
  # @param [String] data A data object
  # @param [Integer] counter A counter for a particular event
  #
  # @return A publisher object
  #
  def get_publisher_object(channel, data, counter)
    OpenStruct.new(
      cid: counter,
      data: OpenStruct.new(
        channel: channel,
        data: data
      ).to_h,
      event: '#publish'
    ).to_h
  end

  # Returns a data model for subscribe and subscribe with acknowledgment event
  #
  # @param [String] channel A channel to subscribe
  # @param [Integer] counter A counter for a particular event
  #
  # @return A subscribe object
  #
  def get_subscribe_object(channel, counter)
    OpenStruct.new(
      event: '#subscribe',
      data: OpenStruct.new(
        channel: channel
      ).to_h,
      cid: counter
    ).to_h
  end

  # Returns a data model for unsubscribe and unsubscribe with acknowledgment event
  #
  # @param [String] channel A channel to unsubscribe
  # @param [Integer] counter A counter for a particular event
  #
  # @return An unsubscribe object
  #
  def get_unsubscribe_object(channel, counter)
    OpenStruct.new(
      event: '#unsubscribe',
      data: channel,
      cid: counter
    ).to_h
  end
end
