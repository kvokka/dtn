# frozen_string_literal: true

module Dtn
  module Lookups
    module Historical
      RSpec.describe TickDay, socket_recorder: "historical tick day" do
        let(:request_options) { { symbol: :aapl, days: 2, max_datapoints: 50 } }

        include_examples "common historical tick"
      end
    end
  end
end
