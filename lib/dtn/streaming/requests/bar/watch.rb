# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Bar
        # Request live interval (bar) data.
        #
        # :param symbol: Symbol for which you are requesting data.
        # :param interval: Interval length in interval_type units (can be fractal)
        # :param interval_type: 's' = secs, 'v' = volume, 't' = ticks
        # :param begin_filter_time: Earliest time of day for which you want data
        # :param end_filter_time: Latest time of day for which you want data
        # :param update_interval: Update the current bar every update secs.
        # :param begin_datetime: Get back-fill bars starting at begin_datetime
        # :param lookback_days: Get lookback_days of backfill data
        # :param lookback_bars: Get lookback_bars of backfill data
        #
        # Only one of begin_datetime, lookback_days or lookback_bars should be set.
        #
        # Requests live interval data. You can also request some backfill data.
        # When you call this function:
        #     1) Client will return HistoricalBar messages with bars
        #     that go back either a) upto begin_datetime, b) upto lookback_days or
        #     c) upto lookback_bars.
        #     2) The callback on observer update_bar is called on every update
        #     to data for the current live bar.
        #     3) The callback current_bar is called every time we cross an
        #     interval boundary with data for the now complete bar.
        class Watch < Request
          TEMPLATE =
            "BW,%<symbol>s,%<interval>d,%<begin_datetime>s,%<lookback_days>s," \
            "%<lookback_bars>s,%<begin_filter_time>s,%<end_filter_time>s,%<id>s," \
            "%<interval_type>s,'',%<update_interval>d\r\n"

          include Dtn::Concerns::Validation
          include Dtn::Concerns::Id

          DEFAULT_BEGIN_FILTER_TIME = "093000"
          DEFAULT_END_FILTER_TIME = "160000"

          LOOKBACK_OPTIONS = %i[begin_datetime lookback_days lookback_bars].freeze

          # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          def call(symbol:, interval: 60, update_interval: 5, **options)
            options.merge!({
                             symbol: symbol.to_s.upcase,
                             interval: validate_int(interval),
                             begin_filter_time: options[:begin_filter_time] || DEFAULT_BEGIN_FILTER_TIME,
                             end_filter_time: options[:end_filter_time] || DEFAULT_END_FILTER_TIME,
                             interval_type: validate_interval_type(options[:interval_type]),
                             update_interval: validate_int(update_interval),
                             id: id,
                             begin_datetime: options[:begin_datetime],
                             lookback_days: options[:lookback_days],
                             lookback_bars: options[:lookback_bars]
                           }).tap { |o| validate_lookback_options(**o) }

            socket.print format(TEMPLATE, options)
          end
          # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

          private

          def validate_lookback_options(**value)
            v = value.slice(*LOOKBACK_OPTIONS)

            return if [
              [false, false, false],
              [true, false, false],
              [false, true, false],
              [false, false, true]
            ].include?(v.values.map(&:present?))

            raise ValidationError, "Only one of '#{LOOKBACK_OPTIONS.join(", ")}' should be entered, but got #{v}"
          end
        end
      end
    end
  end
end
