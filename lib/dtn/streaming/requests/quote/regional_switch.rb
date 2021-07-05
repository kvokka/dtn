# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Quote
        # Request updates when the regional quote for a symbol changes.
        #
        # :param symbol:  A valid symbol for a security or derivative.
        #
        # IQFeed.exe will send a regional message for the symbol whenever
        # the top of book quote on a regional exchange changes. This is
        # the top of book on each exchange where the security or derivative
        # trades, as opposed to the market-wide top of book which you get when
        # you call watch on a symbol. It is NOT the full order book.
        #
        # This produce `level1_summary` message
        class RegionalSwitch < Request
          def call(symbol:, turned_on: true, **)
            socket.puts "S,REG#{turned_on ? "ON" : "OFF"},#{symbol.upcase}\r\n"
          end
        end
      end
    end
  end
end
