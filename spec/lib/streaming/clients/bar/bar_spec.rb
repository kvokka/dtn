# frozen_string_literal: true

module Dtn
  module Streaming
    module Clients
      RSpec.describe Bar, infinite_reads: true do
        include_context "streaming client preparations"

        context "init", socket_recorder: "streaming bar init" do
          before do
            subject
            sleep(0.001) while observer.invoked_methods[:connected].empty?
          end

          it "receive a connected message" do
            expect(observer.invoked_methods[:connected].size).to be_positive
          end
        end

        context "historical bar", socket_recorder: "streaming bar historical" do
          before do
            subject.request.bar.watch symbol: :aapl, lookback_bars: 10
            sleep(0.001) while observer.invoked_methods[:historical_bar].empty?
          end

          it "receive a historical bar" do
            expect(observer.invoked_methods[:historical_bar].size).to be_positive
          end
        end

        context "update bar", socket_recorder: "streaming bar update", require_realtime_data: true do
          before do
            subject.request.bar.watch symbol: :aapl
            sleep(0.001) while observer.invoked_methods[:update_bar].empty?
          end

          it "receive a bar update" do
            expect(observer.invoked_methods[:update_bar].size).to be_positive
          end
        end

        context "current bar", socket_recorder: "streaming bar current", require_realtime_data: true do
          before do
            # using ticks to get current bar faster
            subject.request.bar.watch symbol: :aapl, interval_type: :t, lookback_bars: 10, update_interval: 5
            sleep(0.001) while observer.invoked_methods[:current_bar].empty?
          end

          it "receive a current bar" do
            expect(observer.invoked_methods[:current_bar].size).to be_positive
          end
        end
      end
    end
  end
end
