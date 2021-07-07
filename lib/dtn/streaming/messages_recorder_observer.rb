# frozen_string_literal: true

module Dtn
  module Streaming
    # A sample class, which will record all messages, which were
    # invoked by the client.
    # It will spy and record all invocations for simpler further analyses
    #
    # It's costly for production use, but very convenient for dev &
    # testing purposes to quickly understand what you will get from the
    # API
    class MessagesRecorderObserver
      def invoked_methods
        @invoked_methods ||= Hash.new { |h, k| h[k] = [] }
      end

      def method_missing(method_name, **opts)
        invoked_methods[method_name] << opts[:message]
      end

      def respond_to_missing?(*)
        true
      end
    end
  end
end
