# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      # Tick timframe requests
      class TickTimeframe < Base
        TEMPLATE =
          "HTT,%<symbol>s,%<begin_datetime>s,%<end_datetime>s,%<max_datapoints>d," \
          "%<begin_filter_time>s,%<end_filter_time>s,%<data_direction>d,%<request_id>d," \
          "%<datapoints_per_send>d\r\n"

        # Get historical tick data
        #
        # Example message
        #
        #   HTT,[Symbol],[BeginDate BeginTime],[EndDate EndTime],[MaxDatapoints],[BeginFilterTime],\
        #   [EndFilterTime],[DataDirection],[RequestID],[DatapointsPerSend]<CR><LF>
        def call(symbol:, begin_datetime:, end_datetime:, **options)
          self.combined_options = defaults(**options).merge({
                                                              symbol: symbol.to_s.upcase,
                                                              begin_datetime: begin_datetime.strftime("%Y%m%d %H%M%S"),
                                                              end_datetime: end_datetime.strftime("%Y%m%d %H%M%S")
                                                            })

          socket.print format(TEMPLATE, combined_options)
          request_id
        end
      end
    end
  end
end
