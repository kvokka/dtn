# frozen_string_literal: true

module Dtn
  module Messages
    module System
      # End of the message abstraction.
      class EndOfMessageCharacters < MessageWithSimpleParser
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
end
