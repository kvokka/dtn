# frozen_string_literal: true

module Dtn
  # Message abstraction
  class Message < OpenStruct
    class << self
      def parse(**options)
        new(options)
      end
    end
  end
end
