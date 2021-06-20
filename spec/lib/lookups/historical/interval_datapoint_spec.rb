# frozen_string_literal: true

module Dtn
  module Lookups
    module Historical
      RSpec.describe IntervalDatapoint, socket_recorder: "historical interval datapoint" do
        let(:request_options) { { symbol: :aapl, interval: 3600, max_datapoints: 100 } }

        include_examples "common historical interval"
      end
    end
  end
end
