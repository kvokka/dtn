# frozen_string_literal: true

module Dtn
  module Lookups
    module System
      # Set client name request
      class SetClientName < Base
        def call(name:)
          self.combined_options = { name: name }

          socket.print "S,SET CLIENT NAME,#{name}"
          finish
        end
      end
    end
  end
end
