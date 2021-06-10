# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      # Tick datapoint requests
      class TickDatapoint < Base
        TEMPLATE =
          "HTX,%<symbol>s,%<max_datapoints>d,%<data_direction>d,%<id>d,%<datapoints_per_send>d\r\n"

        # Get historical tick datapoints (the most recent historical ticks)
        #
        # Example message
        #
        #   HTX,[Symbol],[MaxDatapoints],[DataDirection],[RequestID],[DatapointsPerSend]<CR><LF>
        def call(symbol:, **options)
          self.combined_options = defaults(**options).merge(symbol: symbol.to_s.upcase)

          socket.print format(TEMPLATE, combined_options)
          id
        end

        def expected_messages_class
          Messages::Tick
        end
      end
    end
  end
end
