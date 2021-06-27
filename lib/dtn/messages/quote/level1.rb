# frozen_string_literal: true

module Dtn
  module Messages
    module Quote
      # Streaming level1 dynamic data
      class Level1 < MessageWithSimpleParser
        # fetched with Streaming::Clients::Quote.new.request.system.all_update_fieldnames
        # and stored this way to been able to store the returning types
        ALL_FIELDS = {
          "_skip" => nil,
          "Symbol" => :to_s,
          "Exchange ID" => :to_i,
          "Last" => :to_f,
          "Change" => :to_f,
          "Percent Change" => :to_f,
          "Total Volume" => :to_i,
          "Incremental Volume" => :to_i,
          "High" => :to_f,
          "Low" => :to_f,
          "Bid" => :to_f,
          "Ask" => :to_f,
          "Bid Size" => :to_i,
          "Ask Size" => :to_i,
          "Tick" => :to_s,
          "Bid Tick" => :to_s,
          "Range" => :to_s,
          "Last Trade Time" => :to_s,
          "Open Interest" => :to_s,
          "Open" => :to_f,
          "Close" => :to_f,
          "Spread" => :to_f,
          "Strike" => :to_f,
          "Settle" => :to_s,
          "Delay" => :to_s,
          "Market Center" => :to_s,
          "Restricted Code" => :to_s,
          "Net Asset Value" => :to_s,
          "Average Maturity" => :to_s,
          "7 Day Yield" => :to_s,
          "Last Trade Date" => :to_s,
          "(Reserved)" => :to_s,
          "Extended Trading Last" => :to_f,
          "Expiration Date" => :to_s,
          "Regional Volume" => :to_s,
          "Net Asset Value 2" => :to_s,
          "Extended Trading Change" => :to_f,
          "Extended Trading Difference" => :to_f,
          "Price-Earnings Ratio" => :to_f,
          "Percent Off Average Volume" => :to_f,
          "Bid Change" => :to_s,
          "Ask Change" => :to_s,
          "Change From Open" => :to_s,
          "Market Open" => :to_s,
          "Volatility" => :to_s,
          "Market Capitalization" => :to_f,
          "Fraction Display Code" => :to_s,
          "Decimal Precision" => :to_i,
          "Days to Expiration" => :to_s,
          "Previous Day Volume" => :to_i,
          "Regions" => :to_s,
          "Open Range 1" => :to_s,
          "Close Range 1" => :to_s,
          "Open Range 2" => :to_s,
          "Close Range 2" => :to_s,
          "Number of Trades Today" => :to_s,
          "Bid Time" => :to_s,
          "Ask Time" => :to_s,
          "VWAP" => :to_s,
          "TickID" => :to_i,
          "Financial Status Indicator" => :to_s,
          "Settlement Date" => :to_s,
          "Trade Market Center" => :to_i,
          "Bid Market Center" => :to_i,
          "Ask Market Center" => :to_i,
          "Trade Time" => :to_s,
          "Available Regions" => :to_s
        }.freeze
      end
    end
  end
end
