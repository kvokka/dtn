# frozen_string_literal: true

module Dtn
  module Lookups
    module Historical
      # Tick requests
      class Tick < Base
        def expected_messages_class
          Messages::Historical::Tick
        end
      end
    end
  end
end
