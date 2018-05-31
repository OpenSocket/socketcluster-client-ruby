require "ostruct"

# Module DataModels provides Data Models for different objects (JSON Format) for tight coupling
#
# @author Piyush Wani <piyushwww13@gmail.com>
#
module DataModels
  # this is a method which returns data model for acknowledgment object
  #
  # @param [#String] error emit event
  # @param [#String] data data (mainly in string format)
  # @param [#Integer] cid counter
  # @return [#Hash] ack_object in hash format
  #
  def get_ack_object(error, data, cid)
    ack_object = OpenStruct.new({
      cid: cid,
      data: data,
      error: error
    })
    return ack_object.to_h;
  end

  # this is a method which returns data model for emitter object
  #
  # @param [#String] event emit event
  # @param [#Hash] object object is nothing but the data to be sent
  #
  # @return [#Hash] emit_object in hash format
  #
  def get_emit_object(event, object)
    emit_object = OpenStruct.new({
      event: event,
      data: object
    })
    return emit_object.to_h;
  end


  # this is a method which returns data model for emit_ack object
  #
  # @param [#String] event emiter acknowledgment event
  # @param [#Hash] object object is nothing but the data to be sent
  # @param [#Integer] counter counter which is now incremented
  #
  # @return [#Hash] emit_ack_object in hash format
  #
  def get_emit_ack_object(event, object, counter)
    emit_ack_object = OpenStruct.new({
      event: event,
      data: object,
      c_id: counter
    })
    return emit_ack_object.to_h;
  end

  # this is a method which returns data model for handshake object
  #
  # @param [#Integer] counter counter which is now incremented
  #
  # @return [#hash] handshake_object in hash format
  #
  def get_handshake_object(counter)
    auth_token_object = OpenStruct.new({
      authToken: self.auth_token
    })

    handshake_object = OpenStruct.new({
      cid: counter,
      data: auth_token_object.to_h,
      event: '#handshake',
    })
    return handshake_object.to_h
  end

  # this is a method which returns data model for publisher object
  #
  # @param [#String] channel channel where data should be published
  # @param [#String] data data to be published
  # @param [#Integer] counter Counter for event
  #
  # @return [#type] description
  #
  def get_publisher_object(channel, data, counter)
    channel_object = OpenStruct.new({
      channel: channel,
      data: data
    })

    publisher_object = OpenStruct.new({
      cid: counter,
      data: channel_object.to_h,
      event: '#publish'
    })
    return publisher_object.to_h;
  end

  # this is a method which returns data model for subscribe and subscribe_ack object
  #
  # @param [#String] channel channel to subscribe
  # @param [#Integer] counter counter which is now incremented
  #
  # @return [#Hash] subscription_object in hash format
  #
  def get_subscribe_object(channel, counter)
    channel_object = OpenStruct.new({
      channel: channel
    })

    subscribe_object = OpenStruct.new({
      event: "#subscribe",
      data: channel_object.to_h,
      cid: counter
    })
    return subscribe_object.to_h;
  end

  # this is a method which returns data model for unsubscribe and unsubscriber_ack object
  #
  # @param [#String] channel channel to unsubscribe
  # @param [#Integer] counter counter which is now incremented
  #
  # @return [#Hash] subscription_object in hash format
  #
  def get_unsubscribe_object(channel, counter)
    unsubscribe_object = OpenStruct.new({
      event: '#unsubscribe',
      data: channel,
      cid: counter
    })
    return unsubscribe_object.to_h;
  end
end