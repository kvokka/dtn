# frozen_string_literal: true

require "socket"
require "securerandom"

module Dtn
  # Top level client abstraction. Different streams are available on different
  # ports, so we can use it and follow the same pattern
  class Client
    QUEUE_LENGTH = 100_000

    END_OF_MESSAGE_CHARACTERS = /^.,!ENDMSG!/
    NO_DATA_CHARACTERS = "!NO_DATA!"
    SYNTAX_ERROR_CHARACTERS = "!SYNTAX_ERROR!"

    def initialize(name: nil, queue_length: QUEUE_LENGTH)
      @name = name || SecureRandom.alphanumeric(10)
      @queue_length = queue_length

      init_connection
      engine
    end

    attr_reader :name, :queue_length

    def stop
      self.running = false
    end

    def running?
      !!running
    end

    # TODO: refactor this in pretty way

    def system_request
      Requests::System.new(socket)
    end

    def level1_request
      Requests::Level1.new(socket)
    end

    def historical_request
      Requests::Historical.new(socket)
    end

    def response
      Response.new(self)
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
