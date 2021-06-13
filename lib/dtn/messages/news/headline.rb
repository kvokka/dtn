# frozen_string_literal: true

module Dtn
  module Messages
    module News
      # News headline
      class Headline < Base
        class << self
          private

          def text_fields
            {
              _skip: :to_s,
              source: :to_s,
              headline_id: :to_s,
              symbols: :to_s,
              timestamp: :to_datetime,
              text: :to_s
            }
          end
        end
      end
    end
  end
end
