# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Level2
        # Connect.
        class Connect < Request
          def call
            socket.puts "c\r\n"
          end
        end
      end
    end
  end
end
