# frozen_string_literal: true

module Dtn
  # Message abstraction
  class Message < OpenStruct
    class << self
      def parse(line:)
        l = line.split(",")
        new.tap do |n|
          l.zip(fields).each do |value, (attr, converter)|
            n.public_send("#{attr}=", value.public_send(converter))
          end
        end
      end
    end
  end
end
