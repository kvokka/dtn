# frozen_string_literal: true

module Dtn
  module Messages
    # Empty response abstraction
    class NoDataCharacters < Message
      class << self
        def fields
          @fields ||= {
            request_id: :to_i
          }
        end
      end
    end
  end
end
