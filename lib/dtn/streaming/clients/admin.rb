# frozen_string_literal: true

module Dtn
  module Streaming
    module Clients
      # Provides a connection to IQFeed's Administrative socket.
      #
      # Is used to find out the health of the feed, figure out the
      # status of each connection made to IQFeed, and also set various parameters
      # to the feed.
      #
      # See www.iqfeed.net/dev/api/docs/AdminviaTCPIP.cfm
      class Admin < Client
        PORT = 9300

        SUPPORTED_MESSAGES = {
          "S" => Messages::System::Generic,
          "T" => Messages::System::Timestamp,
          "n" => Messages::System::SymbolNotFound,
          "E" => Messages::System::Error
        }.freeze
      end
    end
  end
end
