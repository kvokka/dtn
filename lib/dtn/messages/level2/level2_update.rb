# frozen_string_literal: true

module Dtn
  module Messages
    module Level2
      # Streaming level2 update
      class Level2Update < MessageWithSimpleParser
        class << self
          # rubocop:disable Metrics/MethodLength
          def fields
            @fields ||= {
              _skip: :nil,
              symbol: :to_s,
              mmid: :to_s,
              bid: :to_f,
              ask: :to_f,
              bid_size: :to_i,
              ask_size: :to_i,
              bid_time: :to_s,
              date: :to_s,
              unknown1: :to_s,
              trade_condition_id: :to_i,
              unknown3: :to_s,
              ask_time: :to_s,
              unknown4: :to_s,
              unknown5: :to_s
            }
          end
          # rubocop:enable Metrics/MethodLength
        end

        def trade_condition
          Dtn.trade_conditions_catalog[trade_condition_id]
        end
      end
    end
  end
end
