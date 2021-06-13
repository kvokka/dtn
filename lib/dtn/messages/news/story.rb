# frozen_string_literal: true

module Dtn
  module Messages
    module News
      # News story
      class Story < Base
        class << self
          private

          def text_fields
            {
              text: :to_s
            }
          end
        end
      end
    end
  end
end
