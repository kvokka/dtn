# frozen_string_literal: true

module Dtn
  module Messages
    module System
      # Full client statistics
      class ClientStats < MessageWithSimpleParser
        class << self
          # rubocop:disable Metrics/MethodLength
          def fields
            @fields ||= {
              _skip1: nil,
              _skip2: nil,
              type_int: :to_i,
              client_id: :to_i,
              client_name: :to_s,
              timestamp: :to_s,
              num_sym: :to_i,
              num_reg_sym: :to_i,
              kb_sent: :to_f,
              kb_recvd: :to_f,
              kb_queued: :to_f
            }
          end
          # rubocop:enable Metrics/MethodLength
        end

        def after_initialization
          normalize_type
        end

        private

        def normalize_type
          self.type = case type_int
                      when 0 then :admin
                      when 1 then :quote
                      when 2 then :bar
                      when 3 then :lookup
                      else :unknown
                      end
        end
      end
    end
  end
end
