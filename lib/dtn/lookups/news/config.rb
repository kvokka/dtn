# frozen_string_literal: true

module Dtn
  module Lookups
    module News
      # News config
      class Config < Base
        TEMPLATE = "NCG,%<format_type>s,%<id>d"

        # Returns the News configuration which tells you what news sources
        # you are subscribed to.
        #
        # Example messages
        #
        #   NCG,[XML/Text],[RequestID]<CR><LF>
        def call(format_type: DEFAULT_NEWS_FORMAT_TYPE)
          self.combined_options = defaults.merge(
            format_type: validate_format_type(format_type)
          )
          super
        end
      end
    end
  end
end
