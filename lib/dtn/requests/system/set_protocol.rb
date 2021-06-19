# frozen_string_literal: true

module Dtn
  module Requests
    module System
      # Set protocol
      class SetClientName < Base
        def call
          # protocol version is locked and gem was tested only with client 6.1
          self.combined_options = { version: "6.1" }

          socket.print "S,SET PROTOCOL,#{combined_options[:version]}\r\n"
          finish
        end
      end
    end
  end
end
