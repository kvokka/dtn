# frozen_string_literal: true

module Dtn
  module Messages
    # Price tick message abstraction.
    # Keep in mind, that it this also include heartbeats
    class Tick < Message
      def call; end
    end
  end
end
