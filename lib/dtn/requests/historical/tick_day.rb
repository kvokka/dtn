# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      # Tick days requests
      class TickDay < Tick
        TEMPLATE =
          "HTD,%<symbol>s,%<days>s,%<max_datapoints>d,%<begin_filter_time>s,%<end_filter_time>s," \
          "%<data_direction>d,%<id>d,%<datapoints_per_send>d\r\n"

        # Retrieves ticks for the previous [Days] days for the specified [Symbol].
        #
        # NOTE: Unfortunately I constantly get an empty response with this and
        #       more information about this data point needed.
        #
        # Example message
        #
        #   HTD,[Symbol],[Days],[MaxDatapoints],[BeginFilterTime],[EndFilterTime],[DataDirection],\
        #   [RequestID],[DatapointsPerSend]<CR><LF>
        #
        # @returns Integer id
        def call(symbol:, days:, **options)
          self.combined_options = defaults(**options).merge({
                                                              symbol: symbol.to_s.upcase,
                                                              days: Integer(days) > MAX_INT16 ? MAX_INT16 : days
                                                            })

          super
        end
      end
    end
  end
end
