# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      # Interval requests
      class Interval < Base
        def expected_messages_class
          Messages::Interval
        end

        private

        def validate_interval_type(value)
          return DEFAULT_INTERVAL_TYPE unless value

          it = value.to_s.upcase
          return it if %w[S V T].include?(it)

          raise ValidationError,
                "Got #{value}, but interval_type can be only 'S' for seconds, 'V' for volume or 'T' for ticks"
        end

        def validate_interval(value)
          Integer(value)
        end
      end
    end
  end
end
