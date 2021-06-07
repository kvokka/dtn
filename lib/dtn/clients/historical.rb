# frozen_string_literal: true

module Dtn
  module Clients
    # Historical management methods only
    class Historical < Client
      PORT = 9100

      private

      def init_connection
        system_request.set_client_name(name: @name)
        nil
      end

      # rubocop:disable Metrics/MethodLength
      def engine
        return @engine if @engine

        self.running = true
        @engine = Thread.new do
          while (line = socket.gets)
            sleep(0.1) while queue.length >= max_queue_length

            klass = engine_klass_picker(line)
            break unless running?
            raise("this is a unreachable stub. Got with line: #{line}") unless klass

            queue << klass.parse(line: line[2..])
          end
        end
      end
      # rubocop:enable Metrics/MethodLength

      def engine_klass_picker(line)
        case line
        when /^E/ then Messages::Error
        when Client::END_OF_MESSAGE_CHARACTERS then (self.running = false)
        # when /^T/ then Messages::Tick # maybe another starting symbol
        when /^1/ then Messages::Tick
        end
      end
    end
  end
end
