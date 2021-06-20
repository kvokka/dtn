# frozen_string_literal: true

module Dtn
  module Lookups
    module Historical
      # Interval timeframe requests
      class IntervalTimeframe < Interval
        TEMPLATE =
          "HIT,%<symbol>s,%<interval>d,%<begin_datetime>s,%<end_datetime>s,%<max_datapoints>d,"\
          "%<begin_filter_time>s,%<end_filter_time>s,%<data_direction>d,%<id>d,"\
          "%<datapoints_per_send>d,%<interval_type>s"

        # HIT - Retrieves interval data between [BeginDate BeginTime] and [EndDate EndTime] for the
        # specified [Symbol].
        #
        # Example message
        #
        #   HIT,[Symbol],[Interval],[BeginDate BeginTime],[EndDate EndTime],[MaxDatapoints],\
        #   [BeginFilterTime],[EndFilterTime],[DataDirection],[RequestID],[DatapointsPerSend],\
        #   [IntervalType]<CR><LF>

        def call(symbol:, interval:, begin_datetime:, end_datetime:, **options)
          self.combined_options = defaults(**options).merge(
            {
              symbol: validate_symbol(symbol),
              interval: validate_interval(interval),
              interval_type: validate_interval_type(options[:interval_type]),
              begin_datetime: validate_datetime(begin_datetime),
              end_datetime: validate_datetime(end_datetime)
            }
          )
          super
        end
      end
    end
  end
end
