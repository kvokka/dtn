# frozen_string_literal: true

module Dtn
  module Messages
    module System
      # Parsed timestamp
      class Timestamp < Message
        class << self
          def parse(line:, **)
            new timestamp: line[2..].to_datetime
          end
        end
      end
    end
  end
end
