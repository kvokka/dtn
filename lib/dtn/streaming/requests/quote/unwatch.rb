# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Quote
        # Stop watching a symbol.
        #
        # :param symbol:  A valid symbol for a security or derivative.
        #
        # IQFeed.exe will send stop sending updates for this security. This
        # unwatches trades watches and trades and quotes watches. This also
        # stops all regional quote updates for this security.
        class Unwatch < Request
          def call(symbol:)
            socket.puts "r#{symbol.upcase}\r\n"
          end
        end
      end
    end
  end
end
