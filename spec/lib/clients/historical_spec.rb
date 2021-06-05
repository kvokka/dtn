# frozen_string_literal: true

module Dtn
  module Clients
    RSpec.describe Historical, type: :integration do
      let(:client) { described_class.new.call "test" }

      context "PORT" do
        it "should have correct port" do
          expect(described_class::PORT).to eq 9100
        end
      end

      context "#socket" do
        around do |example|
          TCR.turned_off do
            example.run
          end
        end

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
        let(:begin_datetime) { TESTING_BUSINESS_DAY.change({ hour: 10, min: 0, sec: 0 }) }
        let(:end_datetime) { TESTING_BUSINESS_DAY.change({ hour: 10, min: 10, sec: 0 }) }

        context "historical tick" do
          around do |example|
            TCR.use_cassette("historical_tick") do
              example.run
            end
          end

          before do
            subject.historical_request.tick_timeframe(
              symbol: :aapl,
              begin_datetime: begin_datetime,
              end_datetime: end_datetime,
              max_datapoints: 20
            )
          end

          it {
            binding.pry
          }
        end
      end
    end
  end
end
