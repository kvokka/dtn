# frozen_string_literal: true

module Dtn
  module Messages
    module Quote
      # Streaming level1 fundamental data.
      # Always return full dataset
      class Level1Fundamental < MessageWithSimpleParser
        class << self
          def fields
            @fields ||= Level1::ALL_FUNDAMENTAL_FIELDS
          end
        end
      end
    end
  end
end
