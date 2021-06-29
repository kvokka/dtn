# frozen_string_literal: true

module Dtn
  module Streaming
    # Top level client abstraction. Different streams are available on different
    # ports, so we can use it and follow the same pattern
    class Client
      # Status helper methods
      module Status
        STATUSES = { run: :running, stop: :stopped, initializing: :initialized }.freeze

        STATUSES.each do |k, v|
          define_method(k) { self.status = v }
          define_method("#{v}?") { status == v }
        end

        attr_reader :status

        protected

        attr_writer :status
      end

      include Status

      PROTOCOL_VERSION = "6.1"

      CLIENT_TERMINATION_SIGNALS = %w[TERM INT].freeze

      # @params name             Specify name for this client
      def initialize(name: nil)
        @name = name || SecureRandom.alphanumeric(10)

        initializing

        init_connection
        setup_signals
        engine
      end

      attr_reader :name

      # We are able to filer the incoming data with custom fields
      # using
      attr_accessor :quote_update_fields

      def request
        RequestBuilder.new(client: self)
      end

      def observers
        @observers ||= Set.new
      end

      def to_s
        "Client name: #{name}, status: #{status}"
      end

      def socket
        @socket ||= TCPSocket.open(Dtn.config.host, self.class::PORT)
      end

      private

      def engine
        raise NotImplemented
      end

      def init_connection
        raise NotImplemented
      end

      def setup_signals
        CLIENT_TERMINATION_SIGNALS.each do |signal|
          Signal.trap(signal) { stop }
        end
      end
    end
  end
end
