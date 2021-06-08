# frozen_string_literal: true

module Dtn
  module Requests
    module Level1
      # Watch request
      class Watch < Request
        def call(symbol:)
          socket.puts "w#{symbol.upcase}"
        end
      end
    end
  end
end
