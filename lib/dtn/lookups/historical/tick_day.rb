# frozen_string_literal: true

module Dtn
  module Lookups
    module Historical
      # Tick days requests
      class TickDay < Tick
        TEMPLATE =
          "HTD,%<symbol>s,%<days>s,%<max_datapoints>d,%<begin_filter_time>s,%<end_filter_time>s," \
          "%<data_direction>d,%<id>d,%<datapoints_per_send>d"

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
                                                              symbol: validate_symbol(symbol),
                                                              days: validate_short_int(days)
                                                            })

          super
        end
      end
    end
  end
end
