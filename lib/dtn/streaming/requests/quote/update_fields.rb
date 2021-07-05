# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Quote
        # Set list of fields for level1 summary & updates messages.
        class UpdateFields < Request
          def call(list:)
            arr = normalize(list: list)
            validate(arr: arr)
            arr.delete("Symbol")
            arr.unshift("Symbol")
            client.quote_update_fields = arr

            socket.print "S,SELECT UPDATE FIELDS,#{arr.join(",")}\r\n"
          end

          private

          def normalize(list:)
            case list
            when Array then list
            when String then list.split(",")
            else raise("Only Array or ',' separated string is supported")
            end.map(&:to_s)
          end

          def validate(arr:)
            diff = arr - Messages::Quote::Level1::ALL_FIELDS.keys

            return if diff.empty?

            raise "Found unsupported fields #{diff.join(", ")}"
          end
        end
      end
    end
  end
end
