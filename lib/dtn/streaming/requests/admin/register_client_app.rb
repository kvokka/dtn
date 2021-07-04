# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Admin
        # Register your application with IQFeed.
        #
        # :param product: Developer/Product token from DTN.
        #
        # IQFeed requires all developers to get a developer/app token from
        # them before you develop using IQFeed. You can register you developer
        # token either using the command line used to start IQFeed or here.
        # IQFeed will not connect to DTN servers or send you any data without
        # a developer token.
        class RegisterClientApp < Request
          def call(product:)
            socket.puts "S,REGISTER CLIENT APP,#{product}\r\n"
          end
        end
      end
    end
  end
end
