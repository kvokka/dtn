# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Quote
        # Request a refresh for the symbol.
        #
        # :param symbol:  A valid symbol for a security or derivative.
        #
        # IQFeed.exe will send a summary message and a fundamental message
        # for this security after it receives this message. This is useful if
        # for some reason you believe you have bad data for the security in
        # your cache. It cannot be used to get a data snapshot for a symbol
        # you have not subscribed to. IQFeed.exe will ignore refresh requests
        # for symbols you are not watching.
        #
        # It is a good idea to do this for all symbols you are watching if
        # the feed disconnects and reconnects and you haven't gotten an
        # update shortly after the reconnection.
        class Refresh < Request
          def call(symbol:)
            socket.puts "f#{symbol.upcase}\r\n"
          end
        end
      end
    end
  end
end
