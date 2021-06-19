# frozen_string_literal: true

module Dtn
  module Requests
    module Symbol
      RSpec.describe ByNaic, socket_recorder: "symbol by naic" do
        let(:response) { subject.call search_line: "111" }

        it "produce response with ticks" do
          expect(response).to all(be_an(Dtn::Messages::Symbol::ByNaic))
        end

        context "have attributes"
        %i[request_id naic_code_id symbol listed_market_id security_type_id description].each do |attr|
          it { expect(response.last.public_send(attr)).to be_present }
        end

        it { expect { |b| subject.call(search_line: "111", &b) }.to yield_control }
      end
    end
  end
end
