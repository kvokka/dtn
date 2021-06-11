# frozen_string_literal: true

module Dtn
  module Messages
    # Price tick message abstraction.
    # Keep in mind, that it this also include heartbeats
    class Interval < Message
      class << self
        # rubocop:disable Metrics/MethodLength
        def fields
          @fields ||= {
            request_id: :to_i,
            timestamp: :to_datetime,
            high: :to_f,
            low: :to_f,
            open: :to_f,
            close: :to_f,
            total_volume: :to_i,
            period_volume: :to_i,
            number_of_trades: :to_i
          }
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
