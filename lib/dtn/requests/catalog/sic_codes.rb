# frozen_string_literal: true

module Dtn
  module Requests
    module Catalog
      # Sic codes
      class SicCodes < Base
        TEMPLATE = "SSC\r\n"

        def expected_messages_class
          Messages::Catalog::SicCodes
        end
      end
    end
  end
end
