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
              condition_code: :to_s,
              ask_time: :to_s,
              bid_info_valid: :to_s,
              ask_info_valid: :to_s,
              end_of_message_group: :to_s
            }
          end
          # rubocop:enable Metrics/MethodLength
        end
      end
    end
  end
end
