# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      # User historical requests
      class Base < Request
        class ValidationError < StandardError; end
        # Maximum data allowed per 1 request and per 1 batch
        DEFAULT_MAX_DATAPOINTS = 1_000_000
        DEFAULT_DATAPOINTS_PER_SENT = 500

        # In case we are fetching the data for a few days we can filter all the days
        # from and to. The pattern means %H%M%S
        DEFAULT_BEGIN_FILTER_TIME = "093000"
        DEFAULT_END_FILTER_TIME = "160000"

        # Returned data order
        DEFAULT_DATA_DIRECTION = 1

        DEFAULT_INTERVAL_TYPE = "S"

        MAX_INT16 = 2**16 - 1

        DATE_TIME_FORMAT = "%Y%m%d %H%M%S"
        DATE_FORMAT = "%Y%m%d"

        def call(*)
          socket.print format(self.class.const_get(:TEMPLATE), combined_options)
          id
        end

        protected

        def defaults(**options)
          {
            max_datapoints: DEFAULT_MAX_DATAPOINTS,
            begin_filter_time: DEFAULT_BEGIN_FILTER_TIME,
            data_direction: DEFAULT_DATA_DIRECTION,
            end_filter_time: DEFAULT_END_FILTER_TIME,
            datapoints_per_send: DEFAULT_DATAPOINTS_PER_SENT,
            id: id
          }.merge(options)
        end

        def validate_days(value)
          Integer(value) > MAX_INT16 ? MAX_INT16 : value
        end

        def validate_datetime(value)
          return value.strftime(DATE_TIME_FORMAT) if value.is_a? Date
          return value if value.to_s =~ /^\d{8}\s\d{6}$/

          raise ValidationError, "Entered value '#{value.inspect}' is not following pattern #{DATE_TIME_FORMAT}"
        end

        def validate_date(value)
          return value.strftime(DATE_FORMAT) if value.is_a? Date
          return value if value.to_s =~ /^\d{8}$/

          raise ValidationError, "Entered value '#{value.inspect}' is not following pattern #{DATE_FORMAT}"
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
