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

        class ReplacedPreviousWatch < Message; end

        class RegisterClientApp < Message; end

        class RemoveClientApp < Message; end

        class CurrentLoginid < Message; end

        class CurrentPassword < Message; end

        class LoginInfoSaved < Message; end

        class LoginInfoNotSaved < Message; end

        class AutoconnectOn < Message; end

        class AutoconnectOff < Message; end

        # Gem will support only one protocol version at the time
        class CurrentProtocol < Message
          class << self
            def parse(**)
              super.tap { |message| (message.line =~ /6.1/) || raise("Unsupported protocol: #{message}") }
            end
          end
        end

        class Ip < ParseListFromMessage; end

        class FundamentalFieldnames < ParseListFromMessage; end

        class AllUpdateFieldnames < ParseListFromMessage; end

        # With this return we also updating our vision of the current fields
        class CurrentUpdateFieldnames < ParseListFromMessage
          class << self
            def parse(client:, **)
              super.tap { |message| client.quote_update_fields = message.list }
            end
          end
        end

        class Watches < ParseListFromMessage; end

        class << self
          # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/AbcSize
          def parse(line:, client:, **)
            case line
            when /^S,KEY/ then Obsolete.new
            when /^S,SERVER CONNECTED/ then Connected.new
            when /^S,SERVER DISCONNECTED/ then Disconnected.new
            when /^S,SERVER RECONNECT FAILED/ then ReconnectionFailed.new
            when /^S,SYMBOL LIMIT REACHED/ then SymbolLimitReached.new
            when /^S,CURRENT PROTOCOL,/ then CurrentProtocol.parse(line: line[19..])
            when /^S,IP,/ then Ip.parse(line: line[5..])
            when /^S,CUST,/ then CustomerInfo.parse(line: line[7..])
            when /^S,FUNDAMENTAL FIELDNAMES,/ then FundamentalFieldnames.parse(line: line[25..])
            when /^S,UPDATE FIELDNAMES,/ then AllUpdateFieldnames.parse(line: line[20..])
            when /^S,CURRENT UPDATE FIELDNAMES,/ then CurrentUpdateFieldnames.parse(line: line[28..], client: client)
            when /^S,WATCHES/ then Watches.parse(line: line[10..])
            when /^S,REPLACED PREVIOUS WATCH/ then ReplacedPreviousWatch.parse(line: line[25..])
            when /^S,REGISTER CLIENT APP COMPLETED/ then RegisterClientApp.parse(line: line[31..])
            when /^S,REMOVE CLIENT APP COMPLETED/ then RemoveClientApp.parse(line: line[29..])
            when /^S,CURRENT LOGINID/ then CurrentLoginid.parse(line: line[17..])
            when /^S,CURRENT PASSWORD/ then CurrentPassword.parse(line: line[18..])
            when /^S,LOGIN INFO SAVED/ then LoginInfoSaved.parse(line: line[18..])
            when /^S,LOGIN INFO NOT SAVED/ then LoginInfoNotSaved.parse(line: line[22..])
            when /^S,AUTOCONNECT ON/ then AutoconnectOn.parse(line: line[16..])
            when /^S,AUTOCONNECT OFF/ then AutoconnectOff.parse(line: line[17..])
            when /^S,CLIENTSTATS/ then ClientStats.parse(line: line[13..])
            when /^S,STATS/ then Stats.parse(line: line[8..])
            else new(line: line[2..])
            end
          end
          # rubocop:enable Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/AbcSize
        end
      end
    end
  end
end
