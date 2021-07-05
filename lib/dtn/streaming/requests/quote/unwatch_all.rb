# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Quote
        # Unwatch all symbols.
        class UnwatchAll < Request
          def call
            socket.puts "S,UNWATCH ALL\r\n"
          end
        end
      end
    end
  end
end
