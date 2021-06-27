# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module System
        # Request a list of all fields for level1 summary & updates messages.
        class AllUpdateFieldnames < Request
          def call
            socket.print "S,REQUEST ALL UPDATE FIELDNAMES\r\n"
          end
        end
      end
    end
  end
end
