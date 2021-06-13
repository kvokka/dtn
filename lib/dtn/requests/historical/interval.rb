# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      # Interval requests
      class Interval < Base
        def expected_messages_class
          Messages::Historical::Interval
        end

        private

        def validate_interval_type(value)
          return DEFAULT_INTERVAL_TYPE unless value

          it = value.to_s.downcase
          return it if %w[s v t].include?(it)

          raise ValidationError,
                "Got #{value}, but interval_type can be only 's' for seconds, 'v' for volume or 't' for ticks"
        end

        def validate_interval(value)
          Integer(value)
        end
      end
    end
  end
end
