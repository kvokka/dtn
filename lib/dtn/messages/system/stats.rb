# frozen_string_literal: true

module Dtn
  module Messages
    module System
      # All stats
      class Stats < MessageWithSimpleParser
        class << self
          # rubocop:disable Metrics/MethodLength
          def fields
            @fields ||= {
              server_ip: :to_s,
              server_port: :to_i,
              max_symbols: :to_i,
              number_of_symbols: :to_i,
              clients_connected: :to_i,
              seconds_since_last_update: :to_i,
              reconnections: :to_i,
              attemptedReconnections: :to_i,
              start_time: :to_datetime,
              market_time: :to_datetime,
              status: :to_s,
              iq_feed_version: :to_s,
              loginId: :to_s,
              totalKBsRecv: :to_f,
              kbsPerSecRecv: :to_f,
              avgKBsPerSecRecv: :to_f,
              totalKBsSent: :to_f,
              kbsPerSecSent: :to_f,
              avgKBsPerSecSent: :to_f
            }
          end
          # rubocop:enable Metrics/MethodLength
        end
      end
    end
  end
end
