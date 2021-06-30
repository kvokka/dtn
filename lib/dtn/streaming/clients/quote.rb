# frozen_string_literal: true

module Dtn
  module Streaming
    module Clients
      # Lookup management methods only
      class Quote < Client
        PORT = 5009

        SUPPORTED_MESSAGES = {
          "F" => Messages::Quote::Level1Fundamental,
          "P" => Messages::Quote::Level1Summary,
          "Q" => Messages::Quote::Level1Update,
          "R" => Messages::Quote::Level1Regional,
          "N" => Messages::Quote::Level1News,
          "S" => Messages::System::Generic,
          "T" => Messages::System::Timestamp,
          "n" => Messages::System::SymbolNotFound,
          "E" => Messages::System::Error
        }.freeze

        private

        def init_connection
          request.system.set_protocol
          request.system.set_client_name(name: name)
          request.system.current_update_fieldnames
          nil
        end

        def engine
          @engine ||= Thread.new do
            run
            while running? && (line = socket.gets)
              process_line(line: line)
            end
          end
        end

        def process_line(line:)
          message_class = SUPPORTED_MESSAGES[line[0]] || Messages::Unknown
          message_class.parse(line: line, client: self).tap do |message|
            observers.each do |obs|
              obs.public_send(message.callback_name, message: message) if obs.respond_to?(message.callback_name)
            end
          end
        end
      end
    end
  end
end
