# frozen_string_literal: true

module Dtn
  module Messages
    module Quote
      # Streaming level1 dynamic data
      # This message can not be received outside of trading hours
      class Level1Update < MessageWithSimpleParser
        class << self
          def parse(line:, client:)
            new.tap do |n|
              apply_values instance: n,
                           attributes: Level1::ALL_FIELDS.slice(*client.quote_update_fields),
                           values: line.split(",")
            end
          end
        end
      end
    end
  end
end
