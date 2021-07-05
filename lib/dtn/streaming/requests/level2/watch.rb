# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Level2
        # Watch a symbol.
        #
        # :param symbol:  A valid symbol for a security or derivative.
        class Watch < Request
          def call(symbol:)
            socket.puts "w,#{symbol.upcase}\r\n"
          end
        end
      end
    end
  end
end
