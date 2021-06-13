# frozen_string_literal: true

module Dtn
  module Clients
    RSpec.describe Lookup do
      context "PORT" do
        it "should have correct port" do
          expect(described_class::PORT).to eq 9100
        end
      end

      context "#socket" do
        before do
          allow(TCPSocket).to receive(:open).with("localhost", 9100).and_return(double(print: nil, gets: nil))
        end

        after do
          subject.stop
        end

        it "open the socket with correct defaults" do
          subject
          expect(TCPSocket).to have_received(:open).with("localhost", 9100)
        end
      end

      context "historical integration" do
        let(:begin_datetime) { CURRENT_DAY.change({ hour: 10, min: 0, sec: 0 }) }
        let(:end_datetime) { CURRENT_DAY.change({ hour: 10, min: 10, sec: 0 }) }
        let(:end_date) { CURRENT_DAY }
        let(:begin_date) { CURRENT_DAY - 2.months }

        let(:response) { subject.response.each_from_request(request_id: request_id).to_a }

        include_context "integration specs preparation"

        context "multiple requests, ::new auto_stop: false", socket_recorder: "multiple historical requests" do
          let(:request_id) do
            subject.request.historical.interval_datapoint(symbol: :aapl, interval: 3600, max_datapoints: 10)
          end
          let!(:request_id2) do
            subject.request.historical.interval_datapoint(symbol: :fb, interval: 3600, max_datapoints: 10)
          end
          let!(:request_id3) do
            subject.request.historical.interval_datapoint(symbol: :msft, interval: 3600, max_datapoints: 10)
          end

          subject { described_class.new auto_stop: false }

          let(:response) do
            subject.response.each_with_object({ result: [], finished: 0 }) do |el, acc|
              el.termination? ? acc[:finished] += 1 : acc[:result] << el
              break acc[:result] if acc[:finished] == 3
            end
          end

          it "produce response with intervals" do
            expect(response).to all(be_an(Dtn::Messages::Historical::Interval))
          end

          it "should contain messages of all 3 requests" do
            expect(response.map(&:request_id).uniq).to include 1, 2, 3
          end

          it("should run engine in the end") do
            response
            expect(subject.running?).to be_truthy
          end
        end

        context "single requests" do
          before do
            response
          end

          context "with historical tick request", socket_recorder: "historical tick" do
            let(:request_id) do
              subject.request.historical.tick_timeframe(
                symbol: :aapl,
                begin_datetime: begin_datetime,
                end_datetime: end_datetime,
                max_datapoints: 50
              )
            end

            it "produce response with ticks" do
              expect(response).to all(be_an(Dtn::Messages::Historical::Tick))
            end

            it "have correct combined_options" do
              expect(Request.registry.find(request_id).combined_options).to include(
                *%i[max_datapoints begin_filter_time data_direction end_filter_time
                    datapoints_per_send id symbol begin_datetime end_datetime]
              )
            end

            it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

            it_behaves_like "request registered in registry as", Requests::Historical::TickTimeframe
          end

          context "with historical tick days request", socket_recorder: "historical tick day" do
            let(:request_id) do
              subject.request.historical.tick_day(symbol: :aapl, days: 2, max_datapoints: 50)
            end

            it "produce response with ticks" do
              expect(response).to all(be_an(Dtn::Messages::Historical::Tick))
            end

            it "have correct combined_options" do
              expect(Request.registry.find(request_id).combined_options).to include(
                *%i[max_datapoints begin_filter_time data_direction end_filter_time
                    datapoints_per_send id symbol]
              )
            end

            it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

            it_behaves_like "request registered in registry as", Requests::Historical::TickDay
          end

          context "with historical tick datapoints request", socket_recorder: "historical tick datapoint" do
            let(:request_id) do
              subject.request.historical.tick_datapoint(symbol: :aapl, max_datapoints: 100)
            end

            it "produce response with ticks" do
              expect(response).to all(be_an(Dtn::Messages::Historical::Tick))
            end

            it "have correct combined_options" do
              expect(Request.registry.find(request_id).combined_options).to include(
                *%i[max_datapoints data_direction
                    datapoints_per_send id symbol]
              )
            end

            it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

            it_behaves_like "request registered in registry as", Requests::Historical::TickDatapoint
          end

          context "with historical interval datapoints request", socket_recorder: "historical interval datapoint" do
            let(:request_id) do
              subject.request.historical.interval_datapoint(symbol: :aapl, interval: 3600, max_datapoints: 100)
            end

            it "produce response with intervals" do
              expect(response).to all(be_an(Dtn::Messages::Historical::Interval))
            end

            it "have correct combined_options" do
              expect(Request.registry.find(request_id).combined_options).to include(
                *%i[max_datapoints data_direction interval interval_type
                    datapoints_per_send id symbol]
              )
            end

            it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

            it_behaves_like "request registered in registry as", Requests::Historical::IntervalDatapoint
          end

          context "with historical interval days request", socket_recorder: "historical interval day" do
            let(:request_id) do
              subject.request.historical.interval_day(symbol: :aapl, interval: 3600, max_datapoints: 50, days: 2)
            end

            it "produce response with intervals" do
              expect(response).to all(be_an(Dtn::Messages::Historical::Interval))
            end

            it "have correct combined_options" do
              expect(Request.registry.find(request_id).combined_options).to include(
                *%i[max_datapoints data_direction interval interval_type days
                    datapoints_per_send id symbol]
              )
            end

            it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

            it_behaves_like "request registered in registry as", Requests::Historical::IntervalDay
          end

          context "with historical interval timeframe request", socket_recorder: "historical interval timeframe" do
            let(:request_id) do
              subject.request.historical.interval_timeframe(
                symbol: :aapl,
                interval: 15,
                max_datapoints: 50,
                begin_datetime: begin_datetime,
                end_datetime: end_datetime
              )
            end

            it "produce response with intervals" do
              expect(response).to all(be_an(Dtn::Messages::Historical::Interval))
            end

            it "have correct combined_options" do
              expect(Request.registry.find(request_id).combined_options).to include(
                *%i[max_datapoints data_direction interval interval_type begin_datetime end_datetime
                    datapoints_per_send id symbol]
              )
            end

            it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

            it_behaves_like "request registered in registry as", Requests::Historical::IntervalTimeframe
          end

          context "with historical daily timeframe request", socket_recorder: "historical daily timeframe" do
            let(:request_id) do
              subject.request.historical.daily_timeframe(
                symbol: :aapl,
                begin_date: begin_date,
                end_date: end_date
              )
            end

            it "produce response with ticks" do
              expect(response).to all(be_an(Dtn::Messages::Historical::DailyWeeklyMonthly))
            end

            it "have correct combined_options" do
              expect(Request.registry.find(request_id).combined_options).to include(
                *%i[max_datapoints data_direction begin_date end_date datapoints_per_send id symbol]
              )
            end

            it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

            it_behaves_like "request registered in registry as", Requests::Historical::DailyTimeframe
          end

          context "with historical daily datapoint request", socket_recorder: "historical daily datapoint" do
            let(:request_id) do
              subject.request.historical.daily_datapoint symbol: :aapl, max_datapoints: 50
            end

            it "produce response with ticks" do
              expect(response).to all(be_an(Dtn::Messages::Historical::DailyWeeklyMonthly))
            end

            it "have correct combined_options" do
              expect(Request.registry.find(request_id).combined_options).to include(
                *%i[max_datapoints data_direction datapoints_per_send id symbol]
              )
            end

            it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

            it_behaves_like "request registered in registry as", Requests::Historical::DailyDatapoint
          end

          context "with historical weekly datapoint request", socket_recorder: "historical weekly datapoint" do
            let(:request_id) do
              subject.request.historical.weekly_datapoint symbol: :aapl, max_datapoints: 10
            end

            it "produce response with ticks" do
              expect(response).to all(be_an(Dtn::Messages::Historical::DailyWeeklyMonthly))
            end

            it "have correct combined_options" do
              expect(Request.registry.find(request_id).combined_options).to include(
                *%i[max_datapoints data_direction datapoints_per_send id symbol]
              )
            end

            it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

            it_behaves_like "request registered in registry as", Requests::Historical::WeeklyDatapoint
          end

          context "with historical monthly datapoint request", socket_recorder: "historical monthly datapoint" do
            let(:request_id) do
              subject.request.historical.monthly_datapoint symbol: :aapl, max_datapoints: 10
            end

            it "produce response with ticks" do
              expect(response).to all(be_an(Dtn::Messages::Historical::DailyWeeklyMonthly))
            end

            it "have correct combined_options" do
              expect(Request.registry.find(request_id).combined_options).to include(
                *%i[max_datapoints data_direction datapoints_per_send id symbol]
              )
            end

            it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

            it_behaves_like "request registered in registry as", Requests::Historical::MonthlyDatapoint
          end
        end
      end
    end
  end
end
