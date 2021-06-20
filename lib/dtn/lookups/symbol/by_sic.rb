# frozen_string_literal: true

module Dtn
  module Lookups
    module Symbol
      # Symbol lookup by SIC
      class BySic < Base
        TEMPLATE = "SBS,%<search_line>s,%<id>d"

        # Return symbols in a specific SIC sector.
        #
        # Example messages
        #
        #   SBS,[Search String],[RequestID]<CR><LF>
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
