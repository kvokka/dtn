# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      RSpec.describe DailyDatapoint, socket_recorder: "historical daily datapoint" do
        let(:request_options) { { symbol: :aapl, max_datapoints: 50 } }

        include_examples "common historical daily weekley monthly"
      end
    end
  end
end
