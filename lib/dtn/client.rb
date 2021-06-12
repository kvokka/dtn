# frozen_string_literal: true

module Dtn
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

    MAX_QUEUE_LENGTH = 100_000

    END_OF_MESSAGE_CHARACTERS = /!ENDMSG!/.freeze
    NO_DATA_CHARACTERS = /!NO_DATA!/.freeze
    SYNTAX_ERROR_CHARACTERS = "!SYNTAX_ERROR!"

    # @params name             Specify name for this client
    # @params max_queue_length Limit the number of messages for 1 client to avoid OOM
    # @params auto_stop        If true, stop client after the first user request, needs manual stop otherwise
    def initialize(name: nil, max_queue_length: MAX_QUEUE_LENGTH, auto_stop: true)
      @name = name || SecureRandom.alphanumeric(10)
      @max_queue_length = max_queue_length
      @auto_stop = auto_stop

      initializing

      init_connection
      engine
    end

    attr_reader :name, :max_queue_length, :auto_stop
    alias auto_stop? auto_stop

    def request
      RequestBuilder.new(socket: socket)
    end

    def response
      Response.new(client: self)
    end

    def queue
      @queue ||= SizedQueue.new max_queue_length
    end

    def to_s
      "Client name: #{name}, status: #{status}, queue size: #{queue.size}"
    end

    protected

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
  end
end
