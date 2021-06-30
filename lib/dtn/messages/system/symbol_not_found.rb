# frozen_string_literal: true

module Dtn
  module Messages
    module System
      # Not found symbol for streaming
      class SymbolNotFound < MessageWithSimpleParser
        class << self
          def fields
            @fields ||= {
              _skip: :nil,
              symbol: :to_s
            }
          end
        end
      end
    end
  end
end
