# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      # Daily timeframe requests
      class DailyTimeframe < Interval
        TEMPLATE =
          "HDT,%<symbol>s,%<begin_date>s,%<end_date>s,%<max_datapoints>d,%<data_direction>d,%<id>d\r\n"

        # HID - Retrieves [Days] days of interval data for the specified [Symbol].
        #
        # Example message
        #
        #   HDT,[Symbol],[BeginDate],[EndDate],[MaxDatapoints],[DataDirection],[RequestID],\
        #   [DatapointsPerSend]<CR><LF>
        def call(symbol:, begin_date:, end_date:, **options)
          self.combined_options = defaults(**options).merge(
            {
              symbol: symbol.to_s.upcase,
              begin_date: begin_date.strftime("%Y%m%d"),
              end_date: end_date.strftime("%Y%m%d")
            }
          )
          super
        end

        def expected_messages_class
          Messages::DailyWeeklyMonthly
        end
      end
    end
  end
end
