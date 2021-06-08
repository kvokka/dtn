# frozen_string_literal: true

module Dtn
  module Messages
    # Price tick message abstraction.
    # Keep in mind, that it this also include heartbeats
    class Tick < Message
      class << self
        # rubocop:disable Metrics/MethodLength
        def fields
          @fields ||= {
            request_id: :to_i,
            timestamp: :to_datetime,
            last: :to_f,
            last_size: :to_i,
            total_volume: :to_i,
            bid: :to_f,
            ask: :to_f,
            tick_id: :to_i,
            basis_for_last: :to_s,
            trade_market_center: :to_s,
            trade_aggressor: :to_s,
            day_code: :to_s
          }
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
