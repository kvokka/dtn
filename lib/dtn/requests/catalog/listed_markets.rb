# frozen_string_literal: true

module Dtn
  module Requests
    module Catalog
      # Listed markets
      class ListedMarkets < Base
        TEMPLATE = "SLM\r\n"

        def expected_messages_class
          Messages::Catalog::ListedMarkets
        end
      end
    end
  end
end
