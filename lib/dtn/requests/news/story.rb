# frozen_string_literal: true

module Dtn
  module Requests
    module News
      # News story
      class Story < Base
        NEWS_FORMAT_TYPES = %w[x t e].freeze

        TEMPLATE = "NSY,%<story_id>s,%<format_type>s,%<deliver_to>s,%<id>d"

        # Returns all current news story.
        #
        # Note: email support was not implemented
        #
        # Example messages
        #
        #   NSY,[ID],[XML/Text/Email],[DeliverTo],[RequestID]<CR><LF>
        def call(story_id:, deliver_to: nil, format_type: DEFAULT_NEWS_FORMAT_TYPE)
          self.combined_options = defaults.merge(
            format_type: validate_format_type(format_type),
            deliver_to: deliver_to,
            story_id: story_id
          )
          super
        end

        private

        def validate_format_type(value)
          it = value.to_s.downcase[0]
          return it if [nil, "x", "t", "e"].include?(it)

          raise ValidationError,
                "Got #{value}, but interval_type can be only 't' for text, 'e' for email or 'x' for XML"
        end
      end
    end
  end
end
