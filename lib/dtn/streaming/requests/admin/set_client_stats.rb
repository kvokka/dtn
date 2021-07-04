# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Admin
        # Request client statistics from IQFeed.
        #
        # Call this is you want IQFeed to send you a message every second about
        # the status of every connection. Lets you know things like number of
        # subscriptions and if the connection is buffering.
        class SetClientStats < Request
          def call(turned_on: true, **)
            socket.puts "S,CLIENTSTATS #{turned_on ? "ON" : "OFF"}\r\n"
          end
        end
      end
    end
  end
end
