# frozen_string_literal: true

module Dtn
  module Messages
    module System
      # IP addresses IQFeed.exe is connecting to for data.
      class Ip < Message
        class << self
          def parse(line:, **)
            new list: line.chomp.split(",").uniq
          end
        end
      end
    end
  end
end
