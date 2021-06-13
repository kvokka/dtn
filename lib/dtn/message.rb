# frozen_string_literal: true

module Dtn
  # Message abstraction
  class Message < OpenStruct
    class << self
      def parse(line:)
        values = line.split(",")

        new.tap do |n|
          apply_values instance: n, attributes: fields, values: values
          parse_dynamic_fields(instance: n, values: values[(fields.size)..]) if respond_to?(:parse_dynamic_fields)
        end
      end

      private

      def apply_values(instance:, attributes:, values:)
        attributes.zip(values).each do |(attr, converter), value|
          next if attr.to_s.start_with?("_")

          instance.public_send("#{attr}=", value.public_send(converter))
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
