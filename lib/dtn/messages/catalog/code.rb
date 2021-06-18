# frozen_string_literal: true

module Dtn
  module Messages
    module Catalog
      # Code
      class Code < Message
        class << self
          # this Message does not respect commas
          def parse(line:, **)
            id, *description = line.split(",").reject(&:blank?)

            new.tap do |n|
              n.id = id.to_i
              n.description = description.join(",").gsub('"', "")
            end
          end
        end
      end
    end
  end
end
