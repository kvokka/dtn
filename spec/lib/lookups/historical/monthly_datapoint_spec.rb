# frozen_string_literal: true

module Dtn
  module Lookups
    module Historical
      RSpec.describe MonthlyDatapoint, socket_recorder: "historical monthly datapoint" do
        let(:request_options) { { symbol: :aapl, max_datapoints: 10 } }

        include_examples "common historical daily weekley monthly"
      end
    end
  end
end
