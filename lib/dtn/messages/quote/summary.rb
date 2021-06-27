# frozen_string_literal: true

module Dtn
  module Messages
    module Quote
      # Streaming level1 dynamic data.
      # Always return full dataset
      class Summary < MessageWithSimpleParser
        class << self
          def parse(line:, **)
            new.tap do |n|
              apply_values instance: n, attributes: Level1::ALL_FIELDS, values: line.split(",")
            end
          end
        end
      end
    end
  end
end
