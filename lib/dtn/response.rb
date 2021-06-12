# frozen_string_literal: true

module Dtn
  # Represent response from the client and carry all helper methods
  class Response
    # In case we are have a conflict with a few parallel requests in 1 queue
    class MessageFromAnotherRequestError < StandardError
      def initialize(request_id:, msg:)
        @request_id = request_id
        @msg = msg
        super
      end

      attr_reader :msg, :request_id

      def message
        "Can process only messages from '#{request_id.inspect}' request_id, but got the message: '#{msg.inspect}'"
      end
    end

    include Enumerable
    extend Forwardable

    # Default timeout in seconds to wait until the request appear in the registry
    TIMEOUT = 5

    def initialize(client:)
      @client = client
    end

    # lazily fetch all results from queue.
    # Stops only if the engine stops or if error was raised
    def each
      return to_enum(:each) unless block_given?

      wait_client
      loop do
        next yield(queue.pop) if queue.size.positive?
        next sleep(0.001) if running?

        break
      end
    end

    # Fetch only 1 request specific meaningful messages (omitting all termination messages)
    #
    # Due the limitations it is assumed that the only 1 active request is running on this client!
    # raise if other request message occurs
    def each_from_request(request_id:)
      return to_enum(:each_from_request, request_id: request_id) unless block_given?

      each do |message|
        unless message.request_id == request_id
          raise MessageFromAnotherRequestError.new(request_id: request_id, msg: message)
        end

        break if message.termination?

        yield(message)
      end
    end

    alias each_result each
    delegate to_a: :each
    delegate queue: :client, running?: :client

    private

    attr_reader :client

    def wait_client(timeout: TIMEOUT)
      Timeout.timeout(TIMEOUT) do
        loop do
          break if client.running? || client.stopped?

          sleep(0.001)
        end
      end
    rescue TimeoutError
      raise TimeoutError, "The client engine is not ready after #{timeout} seconds"
    end
  end
end
