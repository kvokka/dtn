# frozen_string_literal: true

module Dtn
  module Messages
    # Price tick message abstraction.
    # Keep in mind, that it this also include heartbeats
    class DailyWeeklyMonthly < Message
      class << self
        def fields
          @fields ||= {
            request_id: :to_i,
            timestamp: :to_datetime,
            high: :to_f,
            low: :to_f,
            open: :to_f,
            close: :to_f,
            period_volume: :to_i,
            open_interest: :to_i
          }
        end
      end
    end
  end
end
