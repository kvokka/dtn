# frozen_string_literal: true

module Dtn
  module Messages
    module Symbol
      # By SIC code
      class BySic < Base
        class << self
          private

          def code_id
            :sic_code_id
          end
        end

        def sic_code
          Dtn.sic_codes_catalog[sic_code_id]
        end
      end
    end
  end
end
