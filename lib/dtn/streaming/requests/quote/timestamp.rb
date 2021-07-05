# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Quote
        # Ask IQFeed.exe to send you a single timestamp message
        # The timestamp message sent by IQFeed.exe is in addition to the
        # messages normally. By default IQFeed.exe sends a timestamp
        # message every second, but you can turn off and turn back on
        # those messages. You probably only want to use this if you have
        # turned off the once a second timestamp messages.
        class Timestamp < Request
          def call(**)
            socket.puts "T\r\n"
          end
        end
      end
    end
  end
end
