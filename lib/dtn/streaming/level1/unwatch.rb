# frozen_string_literal: true

module Dtn
  module Lookups
    module Level1
      # Unwatch request
      class Unwatch < Request
        def call(symbol:)
          socket.puts "r#{symbol.upcase}"
        end
      end
    end
  end
end
