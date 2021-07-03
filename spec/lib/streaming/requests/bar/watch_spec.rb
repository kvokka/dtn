# frozen_string_literal: true

module Dtn
  module Streaming
    module Requests
      module Bar
        RSpec.describe Watch do
          let(:subject) do
            class Foo < described_class
              include Dtn::Concerns::Validation
              public(*private_instance_methods) # rubocop:disable Style/AccessModifierDeclarations
            end.new(client: client)
          end

          context "#validate_lookback_options" do
            let(:client) { nil }
            context "valid" do
              [
                { begin_datetime: false, lookback_days: true, lookback_bars: false },
                { begin_datetime: true, lookback_days: false, lookback_bars: false },
                { begin_datetime: false, lookback_days: false, lookback_bars: true },
                { begin_datetime: false, lookback_days: false, lookback_bars: false }
              ].each do |value|
                it { expect { subject.validate_lookback_options(**value) }.not_to raise_error }
              end
            end

            context "invalid" do
              [
                { begin_datetime: true, lookback_days: false, lookback_bars: true },
                { begin_datetime: false, lookback_days: true, lookback_bars: true },
                { begin_datetime: true, lookback_days: true, lookback_bars: false },
                { begin_datetime: true, lookback_days: true, lookback_bars: true }
              ].each do |value|
                it { expect { subject.validate_lookback_options(**value) }.to raise_error ValidationError }
              end
            end
          end
        end
      end
    end
  end
end
