# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module System
        # Connect request
        class Connect < Request
          def call
            socket.print "S,CONNECT\r\n"
          end
        end
      end
    end
  end
end