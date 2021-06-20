# frozen_string_literal: true

module Dtn
  module Lookups
    module Historical
      RSpec.describe IntervalDay, socket_recorder: "historical interval day" do
        let(:request_options) { { symbol: :aapl, interval: 3600, max_datapoints: 50, days: 2 } }

        include_examples "common historical interval"
      end
    end
  end
end
