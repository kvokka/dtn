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

        context "historical tick" do
          before do
            subject.historical_request.tick_timeframe(
              symbol: :aapl,
              begin_datetime: begin_datetime,
              end_datetime: end_datetime,
              max_datapoints: 50
            )
          end

          let(:response) { subject.response.to_a }

          it "produce response with ticks" do
            expect(response).to all(be_an(Dtn::Messages::Tick))
          end
        end
      end
    end
  end
end
