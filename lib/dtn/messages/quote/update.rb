# frozen_string_literal: true

module Dtn
  module Messages
    module Quote
      # Streaming level1 dynamic data
      # This message can not be received outside of trading hours
      class Update < MessageWithSimpleParser
        class << self
          def parse(line:, client:)
            new.tap do |n|
              apply_values instance: n, attributes: fields(client: client), values: line.split(",")
            end
          end

          private

          def fields(client:)
            return Level1::ALL_FIELDS unless client.quote_update_fields

            Level1::ALL_FIELDS.slice(*client.quote_update_fields)
          end
        end
      end
    end
  end
end
