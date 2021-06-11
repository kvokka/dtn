# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      # Interval requests
      class Interval < Base
        def expected_messages_class
          Messages::Interval
        end
      end
    end
  end
end
