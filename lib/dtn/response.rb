# frozen_string_literal: true

module Dtn
  # Represent response from the client and carry all helper methods
  class Response
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
        next sleep(0.1) if running?

        break
      end
    end

    # Fetch only 1 request specific meaningful messages (omitting all termination messages)
    def each_from_request(request_id:)
      return to_enum(:each_from_request, request_id: request_id) unless block_given?

      each do |message|
        break if message.termination?
        next yield(message) if message.request_id == request_id
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
