# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      # User historical requests
      class Base < Request
        PORT = 9100

        # Maximum data allowed per 1 request and per 1 batch
        DEFAULT_MAX_DATAPOINTS = 1_000_000
        DEFAULT_DATAPOINTS_PER_SEND = 500

        # In case we are fetching the data for a few days we can filter all the days
        # from and to. The pattern means %H%M%S
        DEFAULT_BEGIN_FILTER_TIME = "093000"
        DEFAULT_END_FILTER_TIME = "160000"

        # Returned data order
        DEFAULT_DATA_DIRECTION = 1

        DEFAULT_INTERVAL_TYPE = "s"

        include Concerns::Validation

        private

        def defaults(**options)
          {
            max_datapoints: DEFAULT_MAX_DATAPOINTS,
            begin_filter_time: DEFAULT_BEGIN_FILTER_TIME,
            data_direction: DEFAULT_DATA_DIRECTION,
            end_filter_time: DEFAULT_END_FILTER_TIME,
            datapoints_per_send: DEFAULT_DATAPOINTS_PER_SEND,
            id: id
          }.merge(options)
        end

        def validate_symbol(value)
          v = value.to_s
          return v.upcase if v.length.positive?

          raise ValidationError, "Symbol must be present"
        end
      end
    end
  end
end
