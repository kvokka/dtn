# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      RSpec.describe TickTimeframe, socket_recorder: "historical tick" do
        let(:begin_datetime) { CURRENT_DAY.change({ hour: 10, min: 0, sec: 0 }) }
        let(:end_datetime) { CURRENT_DAY.change({ hour: 10, min: 10, sec: 0 }) }

        let(:request_options) do
          {
            symbol: :aapl,
            begin_datetime: begin_datetime,
            end_datetime: end_datetime,
            max_datapoints: 50
          }
        end

        include_examples "common historical tick"
      end
    end
  end
end
