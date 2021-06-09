# frozen_string_literal: true

module Dtn
  # Top level client abstraction. Different streams are available on different
  # ports, so we can use it and follow the same pattern
  class Client
    MAX_QUEUE_LENGTH = 100_000

    END_OF_MESSAGE_CHARACTERS = /^\d+,!ENDMSG!/.freeze
    NO_DATA_CHARACTERS = /^\d+,E,!NO_DATA!/.freeze
    SYNTAX_ERROR_CHARACTERS = "!SYNTAX_ERROR!"

    def initialize(name: nil, max_queue_length: MAX_QUEUE_LENGTH)
      @name = name || SecureRandom.alphanumeric(10)
      @max_queue_length = max_queue_length

      init_connection
      engine
    end

    attr_reader :name, :max_queue_length

    def stop
      self.running = false
    end

    def running?
      !!running
    end

    def request
      RequestBuilder.new(socket: socket)
    end

    def response
      Response.new(client: self)
    end

    def queue
      @queue ||= Queue.new
    end

    protected

    attr_accessor :running

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
