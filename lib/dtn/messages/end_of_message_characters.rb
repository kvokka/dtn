# frozen_string_literal: true

module Dtn
  module Messages
    # End of the message abstraction.
    class EndOfMessageCharacters < Message
      class << self
        def fields
          @fields ||= {
            request_id: :to_i
          }
        end
      end

      def termination?
        true
      end
    end
  end
end
