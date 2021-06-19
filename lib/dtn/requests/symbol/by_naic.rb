# frozen_string_literal: true

module Dtn
  module Requests
    module Symbol
      # Symbol lookup by NAIC
      class ByNaic < Base
        TEMPLATE = "SBN,%<search_line>s,%<id>d\r\n"

        # Return symbols in a specific NAIC sector.
        #
        # Example messages
        #
        #   SBN,[Search String],[RequestID]<CR><LF>
        def call(search_line:, **options)
          self.combined_options = defaults(**options).merge(
            {
              search_line: search_line
            }
          )
          super
        end
      end
    end
  end
end
