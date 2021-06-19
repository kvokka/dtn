# frozen_string_literal: true

module Dtn
  module Messages
    module Symbol
      # By Filter code
      class ByFilter < Base
        class << self
          def fields
            @fields ||= {
              request_id: :to_i,
              symbol: :to_s,
              listed_market_id: :to_i,
              security_type_id: :to_i,
              description: :to_s
            }
          end
        end
      end
    end
  end
end
