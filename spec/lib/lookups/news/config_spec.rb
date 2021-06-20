# frozen_string_literal: true

module Dtn
  module Lookups
    module News
      RSpec.describe Config do
        context "text", socket_recorder: "news config text" do
          let(:response) { subject.call }

          it "produce response with ticks" do
            expect(response).to all(be_an(Dtn::Messages::News::Config))
          end

          context "have attributes"
          %i[request_id type name auth_code icon_id].each do |attr|
            it { expect(response.last.public_send(attr)).to be_present }
          end

          it { expect { |b| subject.call(&b) }.to yield_control }
        end

        context "xml", socket_recorder: "news config xml" do
          let(:response) { subject.call(format_type: "x") }

          it "produce response with ticks" do
            expect(response).to all(be_an(Dtn::Messages::News::Config))
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
