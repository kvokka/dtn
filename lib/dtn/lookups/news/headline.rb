# frozen_string_literal: true

module Dtn
  module Lookups
    module News
      # News headlines
      class Headline < Base
        TEMPLATE = "NHL,%<sources>s,%<symbols>s,%<format_type>s,%<limit>d,%<date_range>s,%<id>d"

        DEFAULT_NEWS_HEADLINES_LIMIT = 1000

        # Returns all current news headlines.
        #
        # @params sources Array of Strings or ';' separated String,
        #         Filter news sources to query. Default all sources.
        # @params symbols Array of Strings or ';' separated String,
        #         Filter symbols you want news for. Default all symbols.
        # @params date_range String or Date
        #         Filter News only for dates. Default no date filter
        # @params limit Integer
        #         Limit fetching stories, Default 1000
        #
        # Example messages
        #
        #   NHL,[Sources],[Symbols],[XML/Text],[Limit],[Date],[RequestID]
        def call(date_range: "", symbols: [], sources: [], format_type: DEFAULT_NEWS_FORMAT_TYPE,
                 limit: DEFAULT_NEWS_HEADLINES_LIMIT)
          self.combined_options = defaults.merge(
            format_type: validate_format_type(format_type),
            symbols: validate_list(symbols),
            sources: validate_list(sources),
            date_range: validate_date_ranges(date_range),
            limit: limit
          )
          super
        end
      end
    end
  end
end
