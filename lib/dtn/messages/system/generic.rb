# frozen_string_literal: true

module Dtn
  module Messages
    module System
      # Atm we return all system messages class or
      # give it bask as a plain text if it does not know it
      class Generic < Message
        class Obsolete < Message; end

        class Connected < Message; end

        class Disconnected < Message; end

        class ReconnectionFailed < Message; end

        class SymbolLimitReached < Message; end

        class Ip < ParseListFromMessage; end

        class FundamentalFieldnames < ParseListFromMessage; end

        class AllUpdateFieldnames < ParseListFromMessage; end

        class CurrentUpdateFieldnames < ParseListFromMessage; end

        class << self
          # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/AbcSize
          def parse(line:, **)
            case line
            when /^S,KEY/ then Obsolete.new
            when /^S,SERVER CONNECTED/ then Connected.new
            when /^S,SERVER DISCONNECTED/ then Disconnected.new
            when /^S,SERVER RECONNECT FAILED/ then ReconnectionFailed.new
            when /^S,SYMBOL LIMIT REACHED/ then SymbolLimitReached.new
            when /^S,IP,/ then Ip.parse(line: line[5..])
            when /^S,CUST,/ then CustomerInfo.parse(line: line[7..])
            when /^S,FUNDAMENTAL FIELDNAMES,/ then FundamentalFieldnames.parse(line: line[25..])
            when /^S,UPDATE FIELDNAMES,/ then AllUpdateFieldnames.parse(line: line[20..])
            when /^S,CURRENT UPDATE FIELDNAMES,/ then CurrentUpdateFieldnames.parse(line: line[28..])
            else new(line: line[2..])
            end
          end
          # rubocop:enable Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/AbcSize
        end
      end
    end
  end
end
