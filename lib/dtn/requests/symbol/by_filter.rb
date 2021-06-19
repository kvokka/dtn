# frozen_string_literal: true

module Dtn
  module Requests
    module Symbol
      # Symbol lookup by custom filter
      class ByFilter < Base
        TEMPLATE = "SBF,%<field_to_search>s,%<search_line>s,%<filter_type>s,%<filter_value>s,%<id>d"

        # Symbols lookup by user filter.
        #
        # @params field_to_search String, can be 's' for symbols or 'd' for description. Default nil
        # @params filter_type String, can be 'e' for listed_markets or 't' security_types. Default nil
        # @params filter_value Array of Strings or ' ' separated String
        #
        #
        # Example messages
        #
        #    SBF,[Field To Search],[Search String],[Filter Type],[Filter Value],[RequestID]<CR><LF>
        def call(search_line:, **options)
          self.combined_options = defaults(**options).merge(
            {
              search_line: search_line,
              field_to_search: validate_field_to_search(options[:field_to_search]),
              filter_type: validate_filter_type(options[:filter_type]),
              filter_value: validate_filter_value(options[:filter_value], options[:filter_type])
            }
          )
          super
        end

        private

        def validate_field_to_search(value)
          return value if ["", "s", "d"].include?(value.to_s)

          raise ValidationError, "Got #{value}, but field_to_search can be only 's' to search " \
                "be symbols or 'd' to search by descriptions."
        end

        def validate_filter_type(value)
          return value if ["", "e", "t"].include?(value.to_s)

          raise ValidationError, "Got #{value}, but filter_type can be only 'e' for listed_markets "\
                "or 't' for security_types."
        end

        # it assume that filter type was already validated
        def validate_filter_value(value, filter_type)
          catalog = filter_type.to_s == "e" ? Dtn.listed_markets_catalog : Dtn.security_types_catalog
          v = value.is_a?(Array) ? value : value.to_s.split.map(&:to_i)
          v.each { |el| catalog.registered?(el) || raise("Missing #{el} in #{catalog.name} catalog") }
          value
        end
      end
    end
  end
end
