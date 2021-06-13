# frozen_string_literal: true

module Dtn
  module Requests
    module Historical
      # Weekly datapoint requests
      class Datapoint < Base
        # Retrieves up to [maxDatapoints] datapoints of composite daily/weekly/monthly datapoints
        # for the specified [Symbol].
        #
        # Example messages
        #
        #   HDX,[Symbol],[MaxDatapoints],[DataDirection],[RequestID],[DatapointsPerSend]<CR><LF>
        #   HWX,[Symbol],[MaxDatapoints],[DataDirection],[RequestID],[DatapointsPerSend]<CR><LF>
        #   HMX,[Symbol],[MaxDatapoints],[DataDirection],[RequestID],[DatapointsPerSend]<CR><LF>
        def call(symbol:, **options)
          self.combined_options = defaults(**options).merge(symbol: validate_symbol(symbol))
          super
        end

        def expected_messages_class
          Messages::Historical::DailyWeeklyMonthly
        end
      end
    end
  end
end
