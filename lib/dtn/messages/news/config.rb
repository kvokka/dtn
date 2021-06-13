# frozen_string_literal: true

module Dtn
  module Messages
    module News
      # News config
      class Config < Base
        class << self
          private

          def text_fields
            {
              category: :to_s,
              type: :to_s,
              name: :to_s,
              auth_code: :to_s,
              icon_id: :to_s
            }
          end
        end
      end
    end
  end
end
