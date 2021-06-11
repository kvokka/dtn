# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      # Interval datapoint requests
      class IntervalDatapoint < Interval
        TEMPLATE =
          "HIX,%<symbol>s,%<interval>d,%<max_datapoints>d,%<data_direction>d,%<id>d,"\
          "%<datapoints_per_send>d,%<interval_type>s\r\n"

        # HIX - Retrieves [maxDatapoints] number of Intervals of data for the specified [Symbol].
        #
        # Example message
        #
        #   HIX,[Symbol],[Interval],[MaxDatapoints],[DataDirection],[RequestID],[DatapointsPerSend],\
        #   [IntervalType]<CR><LF>
        def call(symbol:, interval:, **options)
          self.combined_options = defaults(**options).merge(
            {
              symbol: symbol.to_s.upcase,
              interval: Integer(interval),
              interval_type: validate_interval_type(interval_type: options[:interval_type])
            }
          )
          super
        end
      end
    end
  end
end
