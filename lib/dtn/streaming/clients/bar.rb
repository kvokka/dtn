# frozen_string_literal: true

module Dtn
  module Streaming
    module Clients
      #   Let's you get live data as interval bar data.
      #
      #   If you are using interval bars for trading, use this class if you want
      #   IQFeed to calculate the interval bars for you and send you interval bars
      #   instead of (or in addition to) receiving every tick. For example, you may
      #   want to get open, high, low, close data for each minute or every 50 trades.
      #
      #   The length of the interval can be in time units, number of trades units
      #   or volume traded units as for bars from HistoryConn.
      #   If you want historical bars, use HistoryConn instead. This class
      #   allows you to get some history, for example if you want the past 5
      #   days's bars to fill in a data structure before you start getting live
      #   data updates. But if you want historical data for back-testing or some
      #   such, you are better off using HistoryConn instead.
      #
      #   Since most historical data that IQFeed gives you is bar data, if you are
      #   just getting started, it may be a good idea to save some live tick-data and
      #   bar-data and compare them so you understand exactly how IQFeed is
      #   filtering ticks and generating it's bars. Different data providers tend to
      #   do this differently, dome better than others and the documentation usually
      #   doesn't get updated when things are changed.
      #
      #   For more info, see:
      #   www.iqfeed.net/dev/api/docs/Derivatives_Overview.cfm
      #   and
      #   www.iqfeed.net/dev/api/docs/Derivatives_StreamingIntervalBars_TCPIP.cfm
      class Bar < Client
        PORT = 9400

        SUPPORTED_MESSAGES = COMMON_SUPPORTED_MESSAGES.merge(
          "BH" => Messages::Bar::HistoricalBar,
          "BC" => Messages::Bar::CurrentBar,
          "BU" => Messages::Bar::UpdateBar
        ).freeze

        def message_class(line:)
          self.class::SUPPORTED_MESSAGES[line[0]] ||
            ((line =~ /\d+,(\w+),.+/) && self.class::SUPPORTED_MESSAGES[Regexp.last_match(1)]) ||
            Messages::Unknown
        end
      end
    end
  end
end
