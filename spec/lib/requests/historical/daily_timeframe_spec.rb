# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      RSpec.describe DailyTimeframe, socket_recorder: "historical daily timeframe" do
        let(:request_options) { { symbol: :aapl, begin_date: begin_date, end_date: end_date, interval_type: :s } }
        let(:end_date) { CURRENT_DAY }
        let(:begin_date) { CURRENT_DAY - 2.months }

        include_examples "common historical daily weekley monthly"
      end
    end
  end
end
