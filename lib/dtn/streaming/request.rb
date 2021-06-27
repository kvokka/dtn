# frozen_string_literal: true

module Dtn
  module Streaming
    # Request abstraction
    class Request
      def initialize(client:)
        @client = client
      end

      # Initialize the request to api, should be used in children classes only
      #
      # @returns nil
      def call(*)
        raise NotImplementedError
      end

      private

      def socket
        client.socket
      end

      attr_reader :client
    end
  end
end
