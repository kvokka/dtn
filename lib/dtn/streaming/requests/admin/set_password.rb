# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Admin
        # Set the user password.
        #
        # :param password: IQFeed subscriber's pwd
        #
        # The user of the app must have a subscription to IQFeed. Pass the user's
        # password either here or in cmd line options when IQFeed is started.
        class SetPassword < Request
          def call(password:)
            socket.puts "S,SET PASSWORD,#{password}\r\n"
          end
        end
      end
    end
  end
end
