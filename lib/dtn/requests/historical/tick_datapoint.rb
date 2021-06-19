# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      # Tick datapoint requests
      class TickDatapoint < Tick
        TEMPLATE =
          "HTX,%<symbol>s,%<max_datapoints>d,%<data_direction>d,%<id>d,%<datapoints_per_send>d"

        # Retrieves up to [MaxDatapoints] number of ticks for the specified [Symbol].
        #
        # Example message
        #
        #   HTX,[Symbol],[MaxDatapoints],[DataDirection],[RequestID],[DatapointsPerSend]<CR><LF>
        def call(symbol:, **options)
          self.combined_options = defaults(**options).merge(symbol: validate_symbol(symbol))

          super
        end
      end
    end
  end
end
