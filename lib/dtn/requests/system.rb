# frozen_string_literal: true

module Dtn
  module Requests
    # User system requests
    class System < Request
      def connect
        socket.print "S,CONNECT\r\n"
      end

      # rubocop:disable Naming/AccessorMethodName
      def set_client_name(name:)
        socket.print "S,SET CLIENT NAME,#{name}\r\n"
      end
      # rubocop:enable Naming/AccessorMethodName
    end
  end
end
