# frozen_string_literal: true

module Dtn
  module Lookups
    module News
      RSpec.describe Story do
        let(:date_range) { (CURRENT_DAY - 1.month)..CURRENT_DAY }

        let(:story_id) do
          News::Headline.call(symbols: :aapl, date_range: date_range, limit: 1).first.story_id
        end

        context "text", socket_recorder: "news story text" do
          let(:response) { subject.call story_id: story_id }

          it "produce response with headlines" do
            expect(response).to all(be_an(Dtn::Messages::News::Story))
          end

          context "have attributes"
          %i[request_id text].each do |attr|
            it { expect(response.last.public_send(attr)).to be_present }
          end

          it { expect { |b| subject.call(story_id: story_id, &b) }.to yield_control }
        end

        context "xml", socket_recorder: "news story xml" do
          let(:response) { subject.call story_id: story_id, format_type: "x" }

          it "produce response with headline" do
            expect(response).to all(be_an(Dtn::Messages::News::Story))
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
