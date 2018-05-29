#
# Module Emitter provides interface to execute events and acknowledgments
#
# @author Maanav Shah <shahmaanav07@gmail.com>
#
module Emitter
  #
  # Initiarizes events and acks in emitter
  #
  #
  #
  #
  def initialize_emitter
    @events = {}
    @events_ack = {}
  end

  #
  # Adds a handler for a particular event
  #
  # @param [String] key An index to insert handler in events
  # @param [Lambda] function A block to execute on event
  #
  #
  #
  def on(key, function)
    @events[key] = function
  end

  #
  # Adds a handler for a particular channel event
  #
  # @param [String] key An index to insert handler in events
  # @param [Lambda] function A block to execute on event
  #
  #
  #
  def onchannel(key, function)
    @events[key] = function
  end

  #
  # Adds an acknowledgment handler for a particular event
  #
  # @param [String] key An index to insert handler in acknowledgment
  # @param [Lambda] function An acknowledgment block to execute on event
  #
  #
  #
  def onack(key, function)
    @events_ack[key] = function
  end

  #
  # Executes a handler for a particular event
  #
  # @param [String] key An index to insert handler in events
  # @param [Hash] object Data received from ScServer
  #
  #
  #
  def execute(key, object)
    function = @events[key] if @events.key?(key)
    function.call(key, object) if function
  end

  #
  # Checks acknowledgment for an event
  #
  # @param [String] key An index to retrieve handler from events
  #
  #
  #
  def haseventack(key)
    @events_ack[key]
  end

  #
  # Executes a handler and an acknowledgment for a particular event
  #
  # @param [String] key An index to retrieve handler from events
  # @param [Hash] object Data received from ScServer
  # @param [Lambda] ack A block to execute as acknowledgment
  #
  #
  #
  def executeack(key, object, ack)
    function = @events_ack[key] if @events_ack.key?(key)
    function.call(key, object, ack) if function
  end
end
