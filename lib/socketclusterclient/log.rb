#
# Module Logger provides an interface to log events
#
# @author Maanav Shah <shahmaanav07@gmail.com>
#
module Log
  #
  # Initializes logger instance and sets logger level
  #
  #
  #
  #
  def initialize_logger
    @logger = Logger.new(STDOUT)
  end

  #
  # Method to get the logger instance
  #
  #
  # @return [Logger] An instance of logger
  #
  def logger
    initialize_logger unless @logger
    @logger
  end

  #
  # Method to disable logging
  #
  #
  #
  #
  def disable_logging
    @logger = nil
  end

  #
  # Method to enable logging
  #
  #
  #
  #
  def enable_logging
    initialize_logger
  end


  #
  # Method to set logging level
  #
  #
  #
  #
  def set_logging_level(level)
    # need to set the logging level, create warning if logging level is invalid
  end


  #
  # Method Create logging context
  #
  #
  #
  #
  def set_logging_context
    # create logging context, which can carry logging information throughout the thread...
  end

end
