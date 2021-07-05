# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Quote
        # Set protocol
        class SetProtocol < Request
          def call
            socket.print "S,SET PROTOCOL,#{Client::PROTOCOL_VERSION}\r\n"
          end
        end
      end
    end
  end
end
