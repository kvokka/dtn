# frozen_string_literal: true

module Dtn
  module Messages
    # Error message abstraction.
    class Error < Message
      def call
        raise "DTN Error: #{line}"
      end
    end
  end
end
