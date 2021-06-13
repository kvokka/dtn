# frozen_string_literal: true

module Dtn
  module Requests
    module Concerns
      # Collection of common validations
      # This gem too small for ActiveModel, so manual approach should be just ok
      module Validation
        DATE_TIME_FORMAT = "%Y%m%d %H%M%S"
        DATE_FORMAT = "%Y%m%d"
        MAX_INT16 = 2**16 - 1

        private

        def validate_datetime(value)
          raise Date::Error unless value.present?

          base = value.is_a?(Date) ? value : value.to_s.to_datetime
          base.strftime(DATE_TIME_FORMAT)
        end

        def validate_date(value)
          raise Date::Error unless value.present?

          base = value.is_a?(Date) ? value : value.to_s.to_date
          base.strftime(DATE_FORMAT)
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
