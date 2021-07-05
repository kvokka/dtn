# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Level2
        # Disconnect.
        class Disconnect < Request
          def call
            socket.puts "x\r\n"
          end
        end
      end
    end
  end
end
