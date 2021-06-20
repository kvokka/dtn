# frozen_string_literal: true

module Dtn
  module Lookups
    module Historical
      RSpec.describe IntervalTimeframe, socket_recorder: "historical interval timeframe" do
        let(:begin_datetime) { CURRENT_DAY.change({ hour: 10, min: 0, sec: 0 }) }
        let(:end_datetime) { CURRENT_DAY.change({ hour: 10, min: 10, sec: 0 }) }

        let(:request_options) do
          {
            symbol: :aapl,
            interval: 15,
            max_datapoints: 50,
            begin_datetime: begin_datetime,
            end_datetime: end_datetime
          }
        end

        include_examples "common historical interval"
      end
    end
  end
end
