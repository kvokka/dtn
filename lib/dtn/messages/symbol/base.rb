# frozen_string_literal: true

module Dtn
  module Messages
    module Symbol
      # Base lookup
      class Base < MessageWithSimpleParser
        class << self
          def fields
            @fields ||= {
              request_id: :to_i,
              code_id => :to_i,
              symbol: :to_s,
              listed_market_id: :to_i,
              security_type_id: :to_i,
              description: :to_s
            }.delete_if { |k, _| !k }.freeze
          end

          private

          def code_id; end
        end

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
