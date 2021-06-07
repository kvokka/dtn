# frozen_string_literal: true

module Dtn
  # Represent response from the client and carry all helper methods
  class Response
    include Enumerable
    extend Forwardable

    def initialize(client)
      @client = client
    end

    # lazily fetch all results from queue.
    # Stops only if the engine stops or if error was raised
    def each
      return to_enum(:each) unless block_given?

      loop do
        next yield(queue.pop) if queue.size.positive?
        next sleep(0.1) if running?

        break
      end
    end

    alias each_result each
    delegate to_a: :each
    delegate queue: :client, running?: :client

    private

    attr_reader :client
  end
end
