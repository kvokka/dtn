# frozen_string_literal: true

module Dtn
  module Requests
    module Catalog
      # Naics codes
      class NaicsCodes < Base
        TEMPLATE = "SNC\r\n"

        def expected_messages_class
          Messages::Catalog::NaicsCodes
        end
      end
    end
  end
end
