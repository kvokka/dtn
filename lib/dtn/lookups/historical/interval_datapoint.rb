# frozen_string_literal: true

module Dtn
  module Lookups
    module Historical
      # Interval datapoint requests
      class IntervalDatapoint < Interval
        TEMPLATE =
          "HIX,%<symbol>s,%<interval>d,%<max_datapoints>d,%<data_direction>d,%<id>d,"\
          "%<datapoints_per_send>d,%<interval_type>s"

        # HIX - Retrieves [maxDatapoints] number of Intervals of data for the specified [Symbol].
        #
        # Example message
        #
        #   HIX,[Symbol],[Interval],[MaxDatapoints],[DataDirection],[RequestID],[DatapointsPerSend],\
        #   [IntervalType]<CR><LF>
        def call(symbol:, interval:, **options)
          self.combined_options = defaults(**options).merge(
            {
              symbol: validate_symbol(symbol),
              interval: validate_int(interval),
              interval_type: validate_interval_type(options[:interval_type])
            }
          )
          super
        end
      end
    end
  end
end
