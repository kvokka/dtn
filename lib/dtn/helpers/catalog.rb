# frozen_string_literal: true

module Dtn
  module Helpers
    # Global catalog helpers
    module Catalog
      def method_missing(method_name, *, **)
        return super unless method_name.to_s.end_with?("_catalog")

        get_catalog(catalog: method_name.to_s.sub(/_catalog$/, ""))
      end

      def respond_to_missing?(method_name, include_private = false)
        method_name.to_s.end_with?("_catalog") || super
      end

      private

      def get_catalog(catalog:)
        v = instance_variable_get("@#{catalog}")
        return v if v

        result = Registry.new(name: catalog).tap do |registry|
          "Dtn::Requests::Catalog::#{catalog.camelcase}".constantize.call.each do |message|
            registry[message.id] = message
          end
        end
        instance_variable_set("@#{catalog}", result)
      end
    end
  end
end
