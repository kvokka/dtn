# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      # Tick requests
      class Tick < Base
        def expected_messages_class
          Messages::Tick
        end
      end
    end
  end
end
