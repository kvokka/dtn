# frozen_string_literal: true

module Dtn
  module Requests
    module Catalog
      RSpec.describe SicCodes, socket_recorder: "catalog sic codes" do
        let(:response) { subject.call }

        it "produce response with ticks" do
          expect(response).to all(be_an(Dtn::Messages::Catalog::SicCodes))
        end

        context "have attributes"
        %i[id description].each do |attr|
          it { expect(response.last.public_send(attr)).to be_present }
        end

        it { expect { |b| subject.call(&b) }.to yield_control }
      end
    end
  end
end
