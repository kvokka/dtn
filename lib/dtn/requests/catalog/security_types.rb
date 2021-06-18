# frozen_string_literal: true

module Dtn
  module Requests
    module Catalog
      # Security types
      class SecurityTypes < Base
        TEMPLATE = "SST\r\n"

        def expected_messages_class
          Messages::Catalog::SecurityTypes
        end
      end
    end
  end
end
