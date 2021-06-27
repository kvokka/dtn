# frozen_string_literal: true

module Dtn
  module Messages
    module Symbol
      # By NAIC code
      class ByNaic < Base
        class << self
          private

          def code_id
            :naic_code_id
          end
        end

        def naic_code
          Dtn.naic_codes_catalog[naic_code_id]
        end
      end
    end
  end
end
