# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Quote
        # Watch a symbol requesting updates only when a trade happens.
        #
        # :param symbol: A valid symbol for a security or derivative.
        #
        # IQFeed.exe will send a summary message for the symbol followed
        # by an update message every time there is a trade.
        class Trades < Request
          def call(symbol:)
            socket.puts "t#{symbol.upcase}\r\n"
          end
        end
      end
    end
  end
end
