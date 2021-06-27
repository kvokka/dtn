# frozen_string_literal: true

module Dtn
  module Messages
    module System
      # Handle a customer information message.
      class CustomerInfo < MessageWithSimpleParser
        class << self
          # rubocop:disable Metrics/MethodLength
          def fields
            @fields ||= {
              svc_type: :to_s,
              ip_address: :to_s,
              port: :to_i,
              token: :to_s,
              version: :to_s,
              _unknown1: :to_s,
              rt_exchanges: :to_s,
              _unknown2: :to_s,
              max_symbols: :to_i,
              flags: :to_s,
              trial_ends: :to_s
            }
          end
          # rubocop:enable Metrics/MethodLength
        end
      end
    end
  end
end
