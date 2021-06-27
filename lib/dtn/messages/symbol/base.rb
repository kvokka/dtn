# frozen_string_literal: true

module Dtn
  module Messages
    module Symbol
      # Base lookup
      class Base < MessageWithSimpleParser
        def listed_market
          Dtn.listed_markets_catalog[listed_market_id]
        end

        def security_type
          Dtn.security_types_catalog[security_type_id]
        end
      end
    end
  end
end
