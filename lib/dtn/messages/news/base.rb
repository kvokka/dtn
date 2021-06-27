# frozen_string_literal: true

module Dtn
  module Messages
    module News
      # Base
      class Base < MessageWithSimpleParser
        class << self
          def fields
            @fields ||= { request_id: :to_i }
          end

          def parse_dynamic_fields(instance:, values:, request:)
            attributes = case request.combined_options[:format_type]
                         when "t" then text_fields
                         when "x" then xml_fields
                         else raise "Wrong format type"
                         end

            apply_values instance: instance, attributes: attributes, values: values
          end

          private

          def xml_fields
            {
              xml: :to_s
            }
          end
        end
      end
    end
  end
end
