# frozen_string_literal: true

module Dtn
  module Messages
    module News
      # News story count
      class StoryCount < Base
        class << self
          private

          def text_fields
            {
              description: :to_s,
              count: :to_i
            }
          end
        end
      end
    end
  end
end
