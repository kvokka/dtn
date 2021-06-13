# frozen_string_literal: true

module Dtn
  module Requests
    module News
      # News story count
      class StoryCount < Base
        TEMPLATE = "NSC,%<symbols>s,%<format_type>s,%<sources>s,%<date>s,%<id>d\r\n"

        DEFAULT_NEWS_HEADLINES_LIMIT = 1000

        # Returns all current news headlines.
        #
        # @params sources Array of Strings or ';' separated String,
        #         Filter news sources to query. Default all sources.
        # @params symbols Array of Strings or ';' separated String,
        #         Filter symbols you want news for. Default all symbols.
        # @params date String or Date
        #         Filter News only for date. Default no date filter
        #
        # Example messages
        #
        #   NSC,[Symbols],[XML/Text],[Sources],[DateRange],[RequestID]<CR>
        def call(date: "", symbols: [], sources: [], format_type: DEFAULT_NEWS_FORMAT_TYPE)
          self.combined_options = defaults.merge(
            format_type: validate_news_format_type(format_type),
            symbols: validate_list(symbols),
            sources: validate_list(sources),
            date: validate_date_ranges(date)
          )
          super
        end

        def expected_messages_class
          Messages::News::StoryCount
        end
      end
    end
  end
end
