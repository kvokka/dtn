# frozen_string_literal: true

module Dtn
  module Concerns
    # Collection of common validations
    # This gem too small for ActiveModel, so manual approach should be just ok
    module Validation
      # Ruby 2.6 support
      class ::Date
        class Error < ArgumentError; end
      end

      DATE_TIME_FORMAT = "%Y%m%d %H%M%S"
      DATE_FORMAT = "%Y%m%d"
      MAX_INT16 = 2**16 - 1

      DEFAULT_INTERVAL_TYPE = "s"

      private

      def validate_interval_type(value)
        return DEFAULT_INTERVAL_TYPE unless value

        it = value.to_s.downcase
        return it if %w[s v t].include?(it)

        raise ValidationError,
              "Got #{value}, but interval_type can be only 's' for seconds, 'v' for volume or 't' for ticks"
      end

      def validate_datetime(value)
        _general_date_validation(value: value, converter: :to_datetime, format: DATE_TIME_FORMAT)
      end

      def validate_date(value)
        _general_date_validation(value: value, converter: :to_date, format: DATE_FORMAT)
      end

      def validate_short_int(value)
        validate_int(value).yield_self do |v|
          v > MAX_INT16 ? MAX_INT16 : v
        end
      end

      def validate_int(value)
        Integer(value)
      rescue TypeError, ArgumentError
        raise ValidationError, "Value '#{value}' is not an integer"
      end

      def validate_float(value)
        Float(value)
      rescue TypeError, ArgumentError
        raise ValidationError, "Value '#{value}' is not a float"
      end

      def _general_date_validation(value:, converter:, format:)
        return if value.blank?

        _convert_date(value: value, converter: converter, format: format)
      rescue ArgumentError
        raise ValidationError, "Value '#{value}' is not a date"
      end

      def _convert_date(value:, converter:, format:)
        base = value.is_a?(Date) ? value : value.to_s.public_send(converter)
        base.strftime(format)
      end
    end
  end
end
