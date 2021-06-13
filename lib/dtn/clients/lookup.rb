# frozen_string_literal: true

module Dtn
  module Clients
    # Lookup management methods only
    class Lookup < Client
      PORT = 9100

      private

      def init_connection
        request.system.set_client_name(name: name)
        nil
      end

      def engine
        @engine ||= Thread.new do
          run
          while running? && (line = socket.gets)
            process_line line: line
          end
        end
      end

      def process_line(line:)
        klass = engine_klass_picker(line)
        raise("this is a unreachable stub. Got with line: #{line}") unless klass

        queue << parse_message(klass: klass, line: line)
        nil
      end

      def parse_message(klass:, line:)
        klass.parse(line: line).tap do |message|
          next unless message.termination?

          Request.registry.find(message.request_id).finish if message.try(:request_id)
          auto_stop? && stop
        end
      end

      def engine_klass_picker(line)
        /^(\d+),(.+)/ =~ line
        request_id = Regexp.last_match(1)
        case (Regexp.last_match(2) || line)
        when Client::END_OF_MESSAGE_CHARACTERS then Messages::System::EndOfMessageCharacters
        when Client::NO_DATA_CHARACTERS then Messages::System::NoDataCharacters
        when /^E/ then Messages::System::Error
        else Request.registry.find(Integer(request_id)).expected_messages_class
        end
      end
    end
  end
end
