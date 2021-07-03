# frozen_string_literal: true

module Dtn
  module Lookups
    module Historical
      # Interval requests
      class Interval < Base
        def expected_messages_class
          Messages::Historical::Interval
        end
      end
    end
  end
end
