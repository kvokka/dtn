# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      # Weekly datapoint requests
      class WeeklyDatapoint < Datapoint
        TEMPLATE =
          "HWX,%<symbol>s,%<max_datapoints>d,%<data_direction>d,%<id>d,%<datapoints_per_send>d"
      end
    end
  end
end
