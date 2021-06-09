# frozen_string_literal: true

module Dtn
  module Requests
    module System
      # Set client name request
      class SetClientName < Request
        def call(name:)
          self.combined_options = { name: name }

          socket.print "S,SET CLIENT NAME,#{name}\r\n"
          finish
        end
      end
    end
  end
end
