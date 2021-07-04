# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Admin
        # Tells IQFeed to autoconnect to DTN servers on startup or not
        #
        # :param turned_on: True means autoconnect, False means don't
        class SetAutoconnect < Request
          def call(turned_on: true, **)
            socket.puts "S,SET AUTOCONNECT,#{turned_on ? "On" : "Off"}\r\n"
          end
        end
      end
    end
  end
end
