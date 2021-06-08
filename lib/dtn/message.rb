# frozen_string_literal: true

module Dtn
  # Message abstraction
  class Message < OpenStruct
    TERMINATION_CLASSES = [
      Messages::EndOfMessageCharacters,
      Messages::NoDataCharacters
    ].freeze

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

    attr_reader :request_id

    def termination?
      TERMINATION_CLASSES.include?(self.class)
    end
  end
end
