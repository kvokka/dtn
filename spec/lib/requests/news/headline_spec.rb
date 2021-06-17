# frozen_string_literal: true

module Dtn
  module Requests
    module News
      RSpec.describe Headline do
        context "text", socket_recorder: "news headlines text" do
          let(:response) { subject.call  limit: 10, symbols: :aapl }

          it "produce response with headlines" do
            expect(response).to all(be_an(Dtn::Messages::News::Headline))
          end

          context "have attributes"
          %i[request_id source story_id symbols timestamp text].each do |attr|
            it { expect(response.last.public_send(attr)).to be_present }
          end

          it { expect { |b| subject.call(&b) }.to yield_control }
        end

        context "xml", socket_recorder: "news headlines xml" do
          let(:response) { subject.call limit: 10, symbols: :aapl, format_type: "x" }

          it "produce response with headline" do
            expect(response).to all(be_an(Dtn::Messages::News::Headline))
          end

          context "have attributes"
          %i[request_id xml].each do |attr|
            it { expect(response.last.public_send(attr)).to be_present }
          end
        end
      end
    end
  end
end
