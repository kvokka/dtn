# frozen_string_literal: true

module Dtn
  module Messages
    # Price tick message abstraction.
    # Keep in mind, that it this also include heartbeats
    class NewsConfig < Message
      class << self
        def fields
          @fields ||= { request_id: :to_i }
        end

        def parse_dynamic_fields(instance:, values:)
          attributes = case Request.registry.find(instance.request_id).combined_options[:format_type]
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

        def text_fields
          {
            category: :to_s,
            type: :to_s,
            name: :to_s,
            auth_code: :to_s,
            icon_id: :to_s
          }
        end
      end
    end
  end
end
