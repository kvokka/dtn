# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Level2
        # Stop watching a symbol.
        #
        # :param symbol:  A valid symbol for a security or derivative.
        class Unwatch < Request
          def call(symbol:)
            socket.puts "r#{symbol.upcase}\r\n"
          end
        end
      end
    end
  end
end
