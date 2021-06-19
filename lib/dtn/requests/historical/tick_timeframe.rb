# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      # Tick timeframe requests
      class TickTimeframe < Tick
        TEMPLATE =
          "HTT,%<symbol>s,%<begin_datetime>s,%<end_datetime>s,%<max_datapoints>d," \
          "%<begin_filter_time>s,%<end_filter_time>s,%<data_direction>d,%<id>d," \
          "%<datapoints_per_send>d"

        # Retrieves tick data between [BeginDate BeginTime] and [EndDate EndTime] for the specified [Symbol].
        #
        # Example message
        #
        #   HTT,[Symbol],[BeginDate BeginTime],[EndDate EndTime],[MaxDatapoints],[BeginFilterTime],\
        #   [EndFilterTime],[DataDirection],[RequestID],[DatapointsPerSend]<CR><LF>
        def call(symbol:, begin_datetime:, end_datetime:, **options)
          self.combined_options = defaults(**options).merge({
                                                              symbol: validate_symbol(symbol),
                                                              begin_datetime: validate_datetime(begin_datetime),
                                                              end_datetime: validate_datetime(end_datetime)
                                                            })

          super
        end
      end
    end
  end
end
