# frozen_string_literal: true

module Dtn
  module Requests
    # User historical requests
    class Historical < Request
      # Maximum data allowed per 1 request and per 1 batch
      DEFAULT_MAX_DATAPOINTS = 1_000_000
      DEFAULT_DATAPOINTS_PER_SENT = 500

      # In case we are fetching the data for a few days we can filter all the days
      # from and to. The pattern means %H%M%S
      DEFAULT_BEGIN_FILTER_TIME = "093000"
      DEFAULT_END_FILTER_TIME = "160000"

      # Returned data order
      DEFAULT_DATA_DIRECTION = 1

      TICK_TIMEFRAME_REQUEST_TEMPLATE =
        "HTT,%<symbol>s,%<begin_datetime>s,%<end_datetime>s,%<max_datapoints>07d," \
        "%<begin_filter_time>s,%<end_filter_time>s,%<data_direction>d,%<request_id>d," \
        "%<datapoints_per_send>d\r\n"

      # Get historical tick data
      #
      # Example message
      #
      #   HTT,[Symbol],[BeginDate BeginTime],[EndDate EndTime],[MaxDatapoints],[BeginFilterTime],\
      #   [EndFilterTime],[DataDirection],[RequestID],[DatapointsPerSend]<CR><LF>
      def tick_timeframe(symbol:, begin_datetime:, end_datetime:, **options)
        socket.printf TICK_TIMEFRAME_REQUEST_TEMPLATE,
                      use_defaults(options).merge({
                                                    symbol: symbol,
                                                    begin_datetime: begin_datetime.strftime("%Y%m%d %H%M%S"),
                                                    end_datetime: end_datetime.strftime("%Y%m%d %H%M%S")
                                                  })
      end

      private

      def use_defaults(**options)
        {
          max_datapoints: DEFAULT_MAX_DATAPOINTS,
          begin_filter_time: DEFAULT_BEGIN_FILTER_TIME,
          data_direction: DEFAULT_DATA_DIRECTION,
          end_filter_time: DEFAULT_END_FILTER_TIME,
          datapoints_per_send: DEFAULT_DATAPOINTS_PER_SENT,
          request_id: next_id
        }.merge(options)
      end
    end
  end
end
