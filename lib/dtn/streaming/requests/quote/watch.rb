# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Quote
        # Watch a symbol requesting updates for both trades and quotes.
        #
        # :param symbol:  A valid symbol for a security or derivative.
        #
        # IQFeed.exe will send a summary message and a fundamental message for
        # the symbol followed by an update message every time there is trade or
        # the top of book quote changes.
        class Watch < Request
          def call(symbol:)
            socket.puts "w#{symbol.upcase}\r\n"
          end
        end
      end
    end
  end
end
