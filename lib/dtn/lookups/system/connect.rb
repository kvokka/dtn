# frozen_string_literal: true

module Dtn
  module Lookups
    module System
      # Connect request
      class Connect < Base
        def call
          socket.print "S,CONNECT"
          finish
        end
      end
    end
  end
end
