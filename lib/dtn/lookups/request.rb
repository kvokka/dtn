# frozen_string_literal: true

module Dtn
  module Lookups
    # Request abstraction
    class Request
      class ValidationError < StandardError; end

      END_OF_MESSAGE_CHARACTERS = /!ENDMSG!/.freeze
      NO_DATA_CHARACTERS = /!NO_DATA!/.freeze
      SYNTAX_ERROR_CHARACTERS = /!SYNTAX_ERROR!/.freeze

      PORT = 9100

      extend Forwardable
      delegate next_id: :"self.class"

      class << self
        def next_id
          _id_tvar.increment
          last_id
        end

        def last_id
          _id_tvar.value
        end

        def call(*args, **opts, &blk)
          new.call(*args, **opts, &blk)
        end

        private

        def _id_tvar
          @_id_tvar ||= Concurrent::AtomicFixnum.new
        end
      end

      attr_accessor :combined_options

      # Initialize the request to api, should be used in children classes only
      #
      # @returns nil or request_id (Integer)
      def call(*, &blk)
        socket.print "#{format(self.class.const_get(:TEMPLATE), combined_options)}\r\n"

        acc = poll_socket(&blk)

        return acc unless block_given?
      end

      def id
        @id ||= next_id
      end

      private

      def poll_socket(acc: [])
        while (line = socket.gets)
          message = engine_klass_picker(line).parse(line: line, request: self)
          break if message.termination?

          block_given? ? yield(message) : acc << message
        end
        acc
      end

      def engine_klass_picker(line)
        /^(\d+,)?(.+)/ =~ line
        payload = Regexp.last_match(2)
        case payload
        when END_OF_MESSAGE_CHARACTERS then Messages::System::EndOfMessageCharacters
        when NO_DATA_CHARACTERS then Messages::System::NoDataCharacters
        when /^E,/, SYNTAX_ERROR_CHARACTERS then Messages::System::Error
        else expected_messages_class
        end
      end

      # This should contain expected class of the returning message.
      # Might be overwritten in child class
      #
      # @returns Class
      def expected_messages_class
        self.class.name.sub("Lookups", "Messages").constantize
      end

      def socket
        @socket ||= TCPSocket.open(Dtn.config.host, PORT)
      end

      def defaults(**options)
        {
          id: id
        }.merge(options)
      end
    end
  end
end
