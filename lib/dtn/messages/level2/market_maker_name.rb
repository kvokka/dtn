# frozen_string_literal: true

module Dtn
  module Messages
    module Level2
      # Streaming level2 MarketMakerName
      class MarketMakerName < MessageWithSimpleParser
        class << self
          def fields
            @fields ||= {
              _skip: :nil,
              mmid: :to_s,
              description: :to_s
            }
          end
        end
      end
    end
  end
end
