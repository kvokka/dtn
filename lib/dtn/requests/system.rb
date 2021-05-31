# frozen_string_literal: true

module Dtn
  module Requests
    # User system requests
    class System < Request
      def connect(name)
        socket.puts "S,CONNECT"
        socket.puts "S,SET CLIENT NAME,#{name}"
      end
    end
  end
end
