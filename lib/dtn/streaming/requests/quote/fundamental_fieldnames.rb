# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Quote
        #   Request a list of all fields in the fundamentals message.
        class FundamentalFieldnames < Request
          def call
            socket.print "S,REQUEST FUNDAMENTAL FIELDNAMES\r\n"
          end
        end
      end
    end
  end
end
