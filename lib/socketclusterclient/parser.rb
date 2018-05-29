#
# Module Parser returns the event to be executed
#
# @author Maanav Shah <shahmaanav07@gmail.com>
#
module Parser
  CHECK_AUTHENTICATION  = 1
  PUBLISH               = 2
  REMOVE_AUTHENTICATION = 3
  SET_AUTHENTICATION    = 4
  EVENT                 = 5
  ACKNOWLEDGEMENT       = 6

  #
  # Provides a handler for a particular event
  #
  # @param [String] event An event to execute
  # @param [Integer] rid An id received from ScServer
  #
  # @return [Enum] Result of parsing event and rid
  #
  def self.parse(event, rid)
    if event.to_s != ''
      if event == '#publish'
        PUBLISH
      elsif event == '#removeAuthToken'
        REMOVE_AUTHENTICATION
      elsif event == '#setAuthToken'
        SET_AUTHENTICATION
      else
        EVENT
      end
    elsif rid == 1
      CHECK_AUTHENTICATION
    else
      ACKNOWLEDGEMENT
    end
  end
end
