# frozen_string_literal: true

module Dtn
  module Messages
    module Catalog
      # Sic codes
      class SicCodes < Message
        class << self
          # this Message does not respect commas
          def parse(line:, request: nil)
            id, *description = line.split(",").select{|f| !f.blank? }

            new.tap do |n|
              n.id = id.to_i
              n.description = description.join(',')
            end
          end
        end
      end
    end
  end
end
