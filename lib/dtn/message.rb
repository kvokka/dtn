# frozen_string_literal: true

module Dtn
  # Message abstraction
  class Message < OpenStruct
    class << self
      def parse(line:)
        l = line.split(",").first(fields.size)
        new.tap do |n|
          l.zip(fields).each do |value, (attr, converter)|
            n.public_send("#{attr}=", value.public_send(converter))
          end
        end
      end
    end

    # After receiving termination Message Request will be marked as finished and #each
    # method successfully finalize the iteration
    def termination?
      false
    end
  end
end
