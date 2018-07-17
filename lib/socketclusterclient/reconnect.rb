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
  # Adds handler for Reconnection
  #
  # @param [Integer] reconnect_interval A interval for reconnection attempt( in MiliSeconds  )
  # @param [Integer] max_reconnect_interval The Max Limit for reconnection interval (in MiliSeconds)
  # @param [Integer] max_attempts The Maximum number of Reconnection Attempts Allowed
  #
  #
  #
  def set_reconnection_listener(reconnect_interval, max_reconnect_interval, max_attempts)
    @reconnect_interval = reconnect_interval > max_reconnect_interval ? max_reconnect_interval : reconnect_interval
    @max_reconnect_interval = max_reconnect_interval
    @max_attempts = max_attempts
    @attempts_made = 0
  end

  #
  # Reconnects to ScServer after delay
  #
  #
  #
  def reconnect
    if @reconnect_interval < @max_reconnect_interval
      @reconnect_interval = @max_reconnect_interval if @reconnect_interval > @max_reconnect_interval
    end

    until reconnection_attempts_finished
      @attempts_made += 1
      @logger.warn("Attempt number : #{@attempts_made} ")
      connect
      sleep(@reconnect_interval / 1000)
    end
    set_reconnection(false)
    @logger.warn('Automatic Reconnection is Disabled')
    @logger.warn('Unable to reconnect: max reconnection attempts reached')
    @attempts_made = 0
  end

  private

  #
  # Checks whether all attempts are finished or not
  #
  #
  # @return [Boolean] Attempts finished
  #
  def reconnection_attempts_finished
    @max_attempts.nil? ?  false : @attempts_made >= @max_attempts
  end
end
