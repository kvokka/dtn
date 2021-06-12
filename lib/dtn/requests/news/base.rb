# frozen_string_literal: true

module Dtn
  module Requests
    module News
      # User news requests
      class Base < Request
        private

        def defaults(**options)
          {
            id: id
          }.merge(options)
        end

        def validate_news_format_type(value)
          return DEFAULT_INTERVAL_TYPE unless value

          it = value.to_s.downcase
          return it if %w[x t].include?(it)

          raise ValidationError, "Got #{value}, but interval_type can be only 't' for text or 'x' for XML"
        end
      end
    end
  end
end
