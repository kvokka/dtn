# frozen_string_literal: true

module Dtn
  module Requests
    # User requests for level 1 data
    class Level1 < Request
      def watch(symbol)
        socket.puts "w#{symbol.upcase}"
      end

      def unwatch(symbol)
        socket.puts "r#{symbol.upcase}"
      end
    end
  end
end
