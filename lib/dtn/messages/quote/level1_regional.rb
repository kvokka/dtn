# frozen_string_literal: true

module Dtn
  module Messages
    module Quote
      # Streaming level1 regional update.
      class Level1Regional < MessageWithSimpleParser
        class << self
          # rubocop:disable Metrics/MethodLength
          def fields
            @fields ||= {
              _skip: :nil,
              "Symbol" => :to_s,
              _skip2: :to_s,
              "Regional Bid" => :to_f,
              "Regional BidSize" => :to_i,
              "Regional BidTime" => :to_time,
              "Regional Ask" => :to_f,
              "Regional AskSize" => :to_i,
              "Regional AskTime" => :to_time,
              "Fraction Display Code" => :to_i,
              "Decimal Precision" => :to_i,
              "Market Center" => :to_i
            }
          end
          # rubocop:enable Metrics/MethodLength
        end
      end
    end
  end
end
