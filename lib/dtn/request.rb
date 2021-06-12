# frozen_string_literal: true

module Dtn
  # Request abstraction
  class Request
    extend Forwardable
    delegate next_id: :'self.class'

    class << self
      def next_id
        _id_tvar.increment
        last_id
      end

      def last_id
        _id_tvar.value
      end

      def registry
        @registry ||= Registry.new(name: "Requests registry")
      end

      private

      def _id_tvar
        @_id_tvar ||= Concurrent::AtomicFixnum.new
      end
    end

    def initialize(socket:)
      @socket = socket
    end

    # Initialize the request to api, should be used in children classes only
    #
    # @returns nil or request_id (Integer)
    def call(*)
      socket.print format(self.class.const_get(:TEMPLATE), combined_options)
      id
    end

    # This should contain expected class of the returning message.
    # Should be overwritten in child class
    #
    # @returns nil or Class
    def expected_messages_class
      raise NotImplementedError
    end

    def finished?
      !!@finished
    end

    def finish
      @finished = true
    end

    def id
      @id ||= next_id
    end

    attr_accessor :combined_options

    protected

    attr_reader :socket
  end
end
