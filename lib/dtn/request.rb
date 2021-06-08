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

      private

      def _id_tvar
        @_id_tvar ||= Concurrent::AtomicFixnum.new
      end
    end

    def initialize(socket)
      @socket = socket
      @request_id = next_id
    end

    def call(*)
      raise NotImplementedError
    end

    attr_reader :request_id

    protected

    attr_reader :socket
  end
end
