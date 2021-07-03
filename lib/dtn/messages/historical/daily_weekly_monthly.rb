# frozen_string_literal: true

module Dtn
  module Messages
    module Historical
      # High timeframe Bar representation
      class DailyWeeklyMonthly < MessageWithSimpleParser
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
end
