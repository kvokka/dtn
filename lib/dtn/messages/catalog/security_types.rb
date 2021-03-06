# frozen_string_literal: true

module Dtn
  module Messages
    module Catalog
      # Security Types
      class SecurityTypes < MessageWithSimpleParser
        class << self
          def fields
            @fields ||= {
              id: :to_i,
              name: :to_s,
              description: :to_s
            }
          end
        end
      end
    end
  end
end
