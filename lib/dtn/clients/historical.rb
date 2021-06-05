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

      def engine
        self.running = true
        Thread.new do
          while (line = socket.gets)
            sleep(1) while queue.length >= queue_length

            klass = engine_klass_picker(line)
            break unless running?

            queue << klass.parse(line: line[2..])
          end
        end
      end

      def engine_klass_picker(line)
        case line
        when /^E/ then Messages::Error
        when Client::END_OF_MESSAGE_CHARACTERS then (self.running = false)
        # when /^T/ then Messages::Tick # maybe another starting symbol
        when /^1/ then Messages::Tick
        else raise("this is a unreachable stub. Got with line: #{line}")
        end
      end
    end
  end
end
