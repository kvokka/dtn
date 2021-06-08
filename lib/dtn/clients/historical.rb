# frozen_string_literal: true

module Dtn
  module Clients
    # Historical management methods only
    class Historical < Client
      PORT = 9100

      private

      def init_connection
        request.system.set_client_name(name: @name)
        nil
      end

      def engine
        return @engine if @engine

        self.running = true
        @engine = Thread.new do
          while (line = socket.gets)
            sleep(0.1) while queue.length >= max_queue_length

            process_line line: line
            break unless running?
          end
        end
      end

      def process_line(line:)
        klass = engine_klass_picker(line)
        raise("this is a unreachable stub. Got with line: #{line}") unless klass

        queue << klass.parse(line: line).tap do |message|
          self.running = false if message.termination?
        end
        nil
      end

      def engine_klass_picker(line)
        case line
        when /^E/ then Messages::Error
        when Client::END_OF_MESSAGE_CHARACTERS then Messages::EndOfMessageCharacters
        when Client::NO_DATA_CHARACTERS then Messages::NoDataCharacters
        # when /^T/ then Messages::Tick # maybe another starting symbol
        when /^\d+/ then Messages::Tick
        end
      end
    end
  end
end
