# frozen_string_literal: true

require "socket"

module Dtn
  # Top level client abstraction. Different streams are available on different
  # ports, so we can use it and follow the same pattern
  class Client
    # setting :end_of_message_characters = "!ENDMSG!"
    # setting :no_data_characters = "!NO_DATA!"
    # setting :syntax_error_characters = "!SYNTAX_ERROR!"

    def call(name)
      Ractor.new do
        system_request.connect(name)
        engine
      end
    end

    def engine
      raise NotImplemented
    end

    # TODO: refactor this in pretty way

    def system_request
      Request::System.new(socket)
    end

    def level1_request(socket)
      Request::Level1.new(socket)
    end

    def historical_request(socket)
      Request::Historical.new(socket)
    end

    protected

    def socket
      @socket ||= TCPSocket.open Dtn.config.host, self.class.config.port
    end
  end
end
