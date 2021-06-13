# frozen_string_literal: true

module Dtn
  module Messages
    # Price tick message abstraction.
    # Keep in mind, that it this also include heartbeats
    class NewsHeadline < Message
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
            _skip: :to_s,
            source: :to_s,
            headline_id: :to_s,
            symbols: :to_s,
            timestamp: :to_datetime,
            text: :to_s
          }
        end
      end
    end
  end
end
