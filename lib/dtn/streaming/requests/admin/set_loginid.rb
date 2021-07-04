# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Admin
        # Set the user login.
        #
        # :param login: IQFeed subscriber's login
        #
        # The user of the app must have a subscription to IQFeed. Pass the user's
        # login either here or in cmd line options when IQFeed is started.
        class SetLoginid < Request
          def call(loginid:)
            socket.puts "S,SET LOGINID,#{loginid}\r\n"
          end
        end
      end
    end
  end
end
