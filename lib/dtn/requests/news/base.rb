# frozen_string_literal: true

module Dtn
  module Requests
    module News
      # User news requests
      class Base < Request
        DEFAULT_NEWS_FORMAT_TYPE = "t"

        include Concerns::Validation

        private

        def defaults(**options)
          {
            id: id
          }.merge(options)
        end

        def validate_news_format_type(value)
          return DEFAULT_NEWS_FORMAT_TYPE unless value

          it = value.to_s.downcase[0]
          return it if %w[x t].include?(it)

          raise ValidationError, "Got #{value}, but interval_type can be only 't' for text or 'x' for XML"
        end

        def validate_list(value)
          return value.join(";") if value.is_a? Array

          value
        end

        def validate_date_range(value)
          return value if value.blank?
          return validate_date if value.is_a? Date

          value.split(":").each do |pair|
            raise(ValidationError, "Your dates range group mess in '#{pair}' part") unless pair =~ /^\d{8}(-\d{8})?$/

            pair.split("-").each { |d| validate_date(d) }
          end
          value
        end
      end
    end
  end
end
