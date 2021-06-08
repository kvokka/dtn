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

      context "#call", socket_recorder: true do
        let(:begin_datetime) { TESTING_BUSINESS_DAY.change({ hour: 10, min: 0, sec: 0 }) }
        let(:end_datetime) { TESTING_BUSINESS_DAY.change({ hour: 10, min: 10, sec: 0 }) }

        let(:response) { subject.response.each_from_request(request_id: request_id).to_a }

        context "with historical tick request" do
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

          it "yet another response do the same" do
            expect(response).to all(be_an(Dtn::Messages::Tick))
          end
        end

        context "with historical tick days request" do
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

          context "few days begin and end" do
            let(:begin_datetime) { TESTING_BUSINESS_DAY.change({ hour: 10, min: 0, sec: 0 }) - 7.days }

            it "should return something useful"
          end
        end
      end
    end
  end
end
