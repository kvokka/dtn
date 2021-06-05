# frozen_string_literal: true

module Dtn
  module Messages
    # Error message abstraction.
    class Error < Message
      class << self
        def parse(line:)
          raise "DTN Error: #{line}"
        end
      end
    end
  end
end
