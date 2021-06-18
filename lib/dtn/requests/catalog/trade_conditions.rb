# frozen_string_literal: true

module Dtn
  module Requests
    module Catalog
      # Trade conditions
      class TradeConditions < Base
        TEMPLATE = "STC\r\n"

        def expected_messages_class
          Messages::Catalog::TradeConditions
        end
      end
    end
  end
end
