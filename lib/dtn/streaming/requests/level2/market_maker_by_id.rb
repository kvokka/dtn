# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Level2
        # Get MarketMakerById
        #
        # :param mmid:  A valid MMID.
        class MarketMakerById < Request
          def call(mmid:)
            socket.puts "m,#{mmid.upcase}\r\n"
          end
        end
      end
    end
  end
end
