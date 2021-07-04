# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Admin
        # Unregister your application  with IQFeed.
        #
        # :param product: Developer/Product token from DTN.
        #
        # Unregister your developer token. Apps from other developers may still
        # be talking to IQFeed. This tells IQFeed that any further calls are
        # from them and not you.
        class RemoveClientApp < Request
          def call(product:)
            socket.puts "S,REMOVE CLIENT APP,#{product}\r\n"
          end
        end
      end
    end
  end
end
