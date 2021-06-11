# frozen_string_literal: true

module Dtn
  # Request builder abstraction
  class RequestBuilder
    # Proxy class between builder and request
    class Proxy
      def initialize(socket:, requests_module:)
        @socket = socket
        @requests_module = requests_module
      end

      def method_missing(method_name, *args, **opts, &blk)
        req = requests_module.const_get(method_name.to_s.camelize).new(socket: socket)
        Request.registry[req.id] = req
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

      attr_reader :socket, :requests_module
    end

    def initialize(socket:)
      @socket = socket
    end

    def method_missing(method_name, *_args, **_opts, &_blk)
      Proxy.new(socket: socket, requests_module: _requests_module(method_name))
    rescue NameError
      super
    end

    def respond_to_missing?(method_name, include_private = false)
      _requests_module(method_name).is_a? Module
    rescue NameError
      super
    end

    private

    attr_reader :socket

    def _requests_module(method_name)
      "Dtn::Requests::#{method_name.to_s.camelize}".constantize
    end
  end
end
