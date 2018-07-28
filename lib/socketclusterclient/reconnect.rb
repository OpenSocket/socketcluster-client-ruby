#
# Module Reconnect provides Reconnection Support
#
# @author Piyush Wani <piyushwww13@gmail.com>
#
module Reconnect
  #
  # Initializes Reconnection related entities
  #
  #
  #
  #
  def initialize_reconnect
    @reconnect_interval = 2000
    @max_reconnect_interval = 30_000
    @max_attempts = nil # unlimited reconnection attempt
    @attempts_made = 0
  end

  #
  # Adds a handler for Reconnection
  #
  # @param [Integer] reconnect_interval A interval for reconnection attempt( in milliseconds  )
  # @param [Integer] max_reconnect_interval A max Limit for reconnection interval (in milliseconds)
  # @param [Integer] max_attempts A max number of Reconnection Attempts allowed
  #
  #
  #
  def set_reconnection_listener(reconnect_interval, max_reconnect_interval, max_attempts = @max_attempts)
    @reconnect_interval = reconnect_interval > max_reconnect_interval ? max_reconnect_interval : reconnect_interval
    @max_reconnect_interval = max_reconnect_interval
    @max_attempts = max_attempts
    @attempts_made = 0
  end

  private

  #
  # Check for reconnection to server
  #
  #
  # @return [Boolean] Allow reconnection
  #
  def should_reconnect
    @enable_reconnection && (@max_attempts.nil? || (@attempts_made < @max_attempts))
  end
end
