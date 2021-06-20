# frozen_string_literal: true

module Dtn
  module Lookups
    module Historical
      # Daily datapoint requests
      class DailyDatapoint < Datapoint
        TEMPLATE =
          "HDX,%<symbol>s,%<max_datapoints>d,%<data_direction>d,%<id>d,%<datapoints_per_send>d"
      end
    end
  end
end
