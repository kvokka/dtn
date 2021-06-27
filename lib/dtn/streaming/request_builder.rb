# frozen_string_literal: true

module Dtn
  module Streaming
    # Request builder abstraction
    class RequestBuilder
      # Proxy class between builder and request
      class Proxy
        def initialize(client:, requests_module:)
          @client = client
          @requests_module = requests_module
        end

        def method_missing(method_name, *args, **opts, &blk)
          req = requests_module.const_get(method_name.to_s.camelize).new(client: client)
          req.call(*args, **opts, &blk)
        rescue NameError
          super
        end

        def respond_to_missing?(method_name, include_private = false)
          requests_module.const_get(method_name.to_s.camelize).is_a? Module
        rescue NameError
          super
        end

        private

        attr_reader :client, :requests_module
      end

      def initialize(client:)
        @client = client
      end

      def method_missing(method_name, *_args, **_opts, &_blk)
        Proxy.new(client: client, requests_module: _requests_module(method_name))
      rescue NameError
        super
      end

      def respond_to_missing?(method_name, include_private = false)
        _requests_module(method_name).is_a? Module
      rescue NameError
        super
      end

      private

      attr_reader :client

      def _requests_module(method_name)
        "Dtn::Streaming::Requests::#{method_name.to_s.camelize}".constantize
      end
    end
  end
end
