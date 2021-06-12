# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      # Daily timeframe requests
      class DailyTimeframe < Interval
        TEMPLATE =
          "HDT,%<symbol>s,%<begin_date>s,%<end_date>s,%<max_datapoints>d,%<data_direction>d,%<id>d\r\n"

        # HDT - Retrieves [Days] days of interval data for the specified [Symbol].
        #
        # Example message
        #
        #   HDT,[Symbol],[BeginDate],[EndDate],[MaxDatapoints],[DataDirection],[RequestID],\
        #   [DatapointsPerSend]<CR><LF>
        def call(symbol:, begin_date:, end_date:, **options)
          self.combined_options = defaults(**options).merge(
            {
              symbol: validate_symbol(symbol),
              begin_date: validate_date(begin_date),
              end_date: validate_date(end_date)
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
