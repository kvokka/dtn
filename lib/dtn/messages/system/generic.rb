# frozen_string_literal: true

# rubocop:disable Lint/EmptyClass
module Dtn
  module Messages
    module System
      # Atm we return all system messages class or
      # give it bask as a plain text if it does not know it
      class Generic < Message
        class Obsolete; end

        class Connected; end

        class Disconnected; end

        class ReconnectionFailed; end

        class SymbolLimitReached; end

        class << self
          # rubocop:disable Metrics/CyclomaticComplexity
          def parse(line:, **)
            case line
            when /^S,KEY/ then Obsolete.new
            when /^S,SERVER CONNECTED/ then Connected.new
            when /^S,SERVER DISCONNECTED/ then Disconnected.new
            when /^S,SERVER RECONNECT FAILED/ then ReconnectionFailed.new
            when /^S,SYMBOL LIMIT REACHED/ then SymbolLimitReached.new
            when /^S,IP,/ then Ip.parse(line: line[5..])
            when /^S,CUST,/ then CustomerInfo.parse(line: line[7..])
            else new(line: line[2..])
            end
          end
          # rubocop:enable Metrics/CyclomaticComplexity
        end
      end
    end
  end
end
# rubocop:enable Lint/EmptyClass
