# frozen_string_literal: true

module Dtn
  module Lookups
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

        private

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
          raise Request::ValidationError, "Value '#{value}' is not an integer"
        end

        def _general_date_validation(value:, converter:, format:)
          return if value.blank?

          base = value.is_a?(Date) ? value : value.to_s.public_send(converter)
          base.strftime(format)
        rescue ArgumentError
          raise Request::ValidationError, "Value '#{value}' is not a date"
        end
      end
    end
  end
end
