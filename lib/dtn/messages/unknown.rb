# frozen_string_literal: true

module Dtn
  module Messages
    # Just in case we got something unexpected.
    # in the best world should be never executed.
    class Unknown < Message
      class << self
        def parse(line:, **)
          new(line: line)
        end
    end
    end
  end
end
