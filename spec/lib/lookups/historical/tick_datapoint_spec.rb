# frozen_string_literal: true

module Dtn
  module Lookups
    module Historical
      RSpec.describe TickDatapoint, socket_recorder: "historical tick datapoint" do
        let(:request_options) { { symbol: :aapl, max_datapoints: 100 } }

        include_examples "common historical tick"
      end
    end
  end
end
