# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module System
        # Request a list of all current fields for level1 summary & updates messages.
        class CurrentUpdateFieldnames < Request
          def call
            socket.print "S,REQUEST CURRENT UPDATE FIELDNAMES\r\n"
          end
        end
      end
    end
  end
end
