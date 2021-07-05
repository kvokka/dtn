# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Quote
        # Turn on/off automatic (1 msg/sec) timestamp messages.
        #
        # Can be done for entire client watches only
        class TimestampSwitch < Request
          def call(turned_on: true, **)
            socket.puts "S,TIMESTAMPS#{turned_on ? "ON" : "OFF"}\r\n"
          end
        end
      end
    end
  end
end
