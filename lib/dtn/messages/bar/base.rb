# frozen_string_literal: true

module Dtn
  module Messages
    module Bar
      # Streaming Bars data.
      class Base < MessageWithSimpleParser
        class << self
          # rubocop:disable Metrics/MethodLength
          def fields
            @fields ||= {
              request_id: :to_i,
              _skip: nil,
              symbol: :to_s,
              timestamp: :to_datetime,
              open: :to_f,
              high: :to_f,
              low: :to_f,
              close: :to_f,
              total_volume: :to_i,
              volume: :to_i,
              number_of_trades: :to_i
            }
          end
          # rubocop:enable Metrics/MethodLength
        end
      end
    end
  end
end
