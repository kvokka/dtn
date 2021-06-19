# frozen_string_literal: true

module Dtn
  module Messages
    module Symbol
      # By NAIC code
      class ByNaic < Base
        class << self
          def fields
            @fields ||= {
              request_id: :to_i,
              naic_code_id: :to_i,
              symbol: :to_s,
              listed_market_id: :to_i,
              security_type_id: :to_i,
              description: :to_s
            }
          end
        end

        def naic_code
          Dtn.sic_codes_catalog[naic_code_id]
        end
      end
    end
  end
end
