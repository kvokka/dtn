# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Admin
        #  Tells IQFeed to save the login info
        #
        # :param turned_on: True means save info, False means don't
        class SaveLoginInfo < Request
          def call(turned_on: true, **)
            socket.puts "S,SET SAVE LOGIN INFO,#{turned_on ? "On" : "Off"}\r\n"
          end
        end
      end
    end
  end
end
