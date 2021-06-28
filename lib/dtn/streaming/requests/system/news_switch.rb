# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module System
        # Turn on/off real-time news messages.
        #
        # Can be done for entire client watches only
        class NewsSwitch < Request
          def call(turned_on: true, **)
            socket.puts "S,NEWS#{turned_on ? "ON" : "OFF"}\r\n"
          end
        end
      end
    end
  end
end
