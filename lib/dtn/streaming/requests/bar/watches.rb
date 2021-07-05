# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Bar
        # Request a current watches message.
        #
        # IQFeed.exe will send you a list of all securities currently watched
        #
        # process_watched_symbols is called in each listener when the list of
        # current watches message is received.
        class Watches < Request
          def call
            socket.puts "S,REQUEST WATCHES\r\n"
          end
        end
      end
    end
  end
end
