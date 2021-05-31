# frozen_string_literal: true

module Dtn
  module Clients
    # Historical management methods only
    class Historical < Client
      setting :port, 9100

      def engine
        while (line = socket.gets)
          klass = case line[0]
                  when "E" then Messages::Error
                  when "T" then Messages::Tick # maybe another starting symbol
                  end
          Ractor.send klass.new(line[2..]).call
        end
      end
    end
  end
end
