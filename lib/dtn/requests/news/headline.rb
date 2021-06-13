# frozen_string_literal: true

module Dtn
  module Requests
    module News
      # News headlines
      class Headline < Base
        TEMPLATE = "NHL,%<sources>s,%<symbols>s,%<format_type>s,%<limit>d,%<date>s,%<id>d\r\n"

        DEFAULT_NEWS_HEADLINES_LIMIT = 1000

        # Returns all current news headlines.
        #
        # @params sources Array of Strings or ';' separated String,
        #         Filter news sources to query. Default all sources.
        # @params symbols Array of Strings or ';' separated String,
        #         Filter symbols you want news for. Default all symbols.
        # @params date String or Date
        #         Filter News only for date. Default no date filter
        # @params limit Integer
        #         Limit fetching stories, Default 1000
        #
        # Example messages
        #
        #   NHL,[Sources],[Symbols],[XML/Text],[Limit],[Date],[RequestID]
        def call(date: "", symbols: [], sources: [], format_type: DEFAULT_NEWS_FORMAT_TYPE,
                 limit: DEFAULT_NEWS_HEADLINES_LIMIT)
          self.combined_options = defaults.merge(
            format_type: validate_news_format_type(format_type),
            symbols: validate_list(symbols),
            sources: validate_list(sources),
            date: validate_date_range(date),
            limit: limit
          )
          super
        end

        def expected_messages_class
          Messages::NewsHeadline
        end
      end
    end
  end
end
