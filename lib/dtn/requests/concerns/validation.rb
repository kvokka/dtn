# frozen_string_literal: true

module Dtn
  module Requests
    module Concerns
      # Collection of common validations
      # This gem too small for ActiveModel, so manual approach should be just ok
      module Validation
        unless defined?(::Date::Error)
          # Ruby 2.6 support
          class ::Date
            class Error < StandardError; end
          end
        end

        DATE_TIME_FORMAT = "%Y%m%d %H%M%S"
        DATE_FORMAT = "%Y%m%d"
        MAX_INT16 = 2**16 - 1

        private

        def validate_datetime(value)
          return if value.blank?

          base = value.is_a?(Date) ? value : value.to_s.to_datetime
          base.strftime(DATE_TIME_FORMAT)
        rescue ArgumentError, Date::Error
          raise Request::ValidationError, "Value '#{value}' is not a date & time"
        end

        def validate_date(value)
          return if value.blank?

          base = value.is_a?(Date) ? value : value.to_s.to_date
          base.strftime(DATE_FORMAT)
        rescue ArgumentError, Date::Error
          raise Request::ValidationError, "Value '#{value}' is not a date"
        end

        def validate_short_int(value)
          validate_int(value).yield_self do |v|
            v > MAX_INT16 ? MAX_INT16 : v
          end
        end

        def validate_int(value)
          Integer(value)
        rescue StandardError
          raise Request::ValidationError, "Value '#{value}' is not an integer"
        end
      end
    end
  end
end
