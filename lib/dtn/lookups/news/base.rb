# frozen_string_literal: true

module Dtn
  module Lookups
    module News
      # User news requests
      class Base < Request
        DEFAULT_NEWS_FORMAT_TYPE = "t"

        include Dtn::Concerns::Validation

        private

        def validate_format_type(value)
          it = value.to_s.downcase[0]
          return it if [nil, "x", "t"].include?(it)

          raise ValidationError, "Got #{value}, but interval_type can be only 't' for text or 'x' for XML"
        end

        def validate_list(value)
          return value.join(";") if value.is_a? Array

          value
        end

        # Date range validator.
        # Consume Date, Range or String as a values (or any combination of them as the args,
        # Array including)
        # Returns Dtn valid String
        class DateRangeValidator
          include Dtn::Concerns::Validation

          def initialize(*values)
            @values = values.flatten
          end

          def call
            return "" if empty_values?

            check_each_value.join(":")
          end

          private

          attr_reader :values

          def empty_values?
            values.all?(&:blank?)
          end

          def check_each_value
            values.inject([]) do |acc, value|
              case value
              when Date then acc.push(check_date(value))
              when Range then acc.push(check_range(value))
              else acc + check(value)
              end
            end
          end

          def check_date(value)
            validate_date(value)
          end

          def check_range(value)
            "#{validate_date(value.begin)}-#{validate_date(value.end)}"
          end

          def check(value)
            value.split(":").map do |pair|
              raise(ValidationError, "Wrong dates range group in '#{pair}'") unless pair =~ /^\d{8}(-\d{8})?$/

              pair.to_s.split("-").map { |d| validate_date(d) }.join("-")
            end
          end
        end

        def validate_date_ranges(*values)
          DateRangeValidator.new(*values).call
        end
      end
    end
  end
end
