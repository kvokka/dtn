# frozen_string_literal: true

module Dtn
  module Clients
    RSpec.describe Historical do
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

      context "#call" do
        let(:begin_datetime) { CURRENT_DAY.change({ hour: 10, min: 0, sec: 0 }) }
        let(:end_datetime) { CURRENT_DAY.change({ hour: 10, min: 10, sec: 0 }) }

        let(:response) { subject.response.each_from_request(request_id: request_id).to_a }

        before do
          Request.registry.clear
          allow(Request).to receive(:next_id).and_return(1, 2, 3, 4, 5)
          # we must fetch all the data first for every request, cos the requests may run in different order
          request_id
          response
        end

        after do
          subject.stop
        end

        around do |example|
          Timeout.timeout(5) do
            example.run
          end
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
            expect(response).to all(be_an(Dtn::Messages::Tick))
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

        context "with historical tick days request", socket_recorder: "historical tick days" do
          let(:request_id) do
            subject.request.historical.tick_day(
              symbol: :aapl,
              days: 7,
              begin_datetime: begin_datetime,
              end_datetime: end_datetime,
              max_datapoints: 50
            )
          end

          context "intraday begin and end" do
            it "produce empty response" do
              expect(response).to be_empty
            end
          end

          it "have correct combined_options" do
            expect(Request.registry.find(request_id).combined_options).to include(
              *%i[max_datapoints begin_filter_time data_direction end_filter_time
                  datapoints_per_send id symbol begin_datetime end_datetime]
            )
          end

          it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

          it_behaves_like "request registered in registry as", Requests::Historical::TickDay

          context "few days begin and end" do
            let(:begin_datetime) { CURRENT_DAY.change({ hour: 10, min: 0, sec: 0 }) - 7.days }

            it "should return something useful"
          end
        end

        context "with historical tick datapoints request", socket_recorder: "historical tick datapoint" do
          let(:request_id) do
            subject.request.historical.tick_datapoint(symbol: :aapl, max_datapoints: 100)
          end

          it "produce response with ticks" do
            expect(response).to all(be_an(Dtn::Messages::Tick))
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
            subject.request.historical.interval_datapoint(symbol: :aapl, interval: 60*60, max_datapoints: 100)
          end

          it "produce response with ticks" do
            expect(response).to all(be_an(Dtn::Messages::Interval))
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
      end
    end
  end
end
