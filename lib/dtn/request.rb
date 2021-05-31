# frozen_string_literal: true

module Dtn
  # Request abstraction
  class Request
    extend Forwardable
    delegate next_id: :'self.class'

    class << self
      # Atm i do not know if it is even possible to cancel existed request,
      # so we care only about the next_ request number.
      def next_id
        Ractor.atomically do
          _id_tvar.value += 1
        end
        _id_tvar.value
      end

      private

      def _id_tvar
        @_id_tvar ||= Ractor::TVar.new(0)
      end
    end

    def initialize(socket)
      @socket = socket
    end

    protected

    attr_reader :socket
  end
end
