# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Quote
        # Set client name request
        class SetClientName < Request
          def call(name:)
            socket.print "S,SET CLIENT NAME,#{name}\r\n"
          end
        end
      end
    end
  end
end
