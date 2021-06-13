# frozen_string_literal: true

module Dtn
  module Messages
    module System
      # Empty response abstraction
      class NoDataCharacters < Message
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
