# frozen_string_literal: true

module Dtn
  module Lookups
    module Symbol
      RSpec.describe ByFilter, socket_recorder: "symbol by filter" do
        let(:response) { subject.call field_to_search: "s", search_line: "aap", filter_type: "t", filter_value: "1" }
        let(:registry) { instance_double "Registry", registered?: true }

        before do
          allow(Dtn).to receive(:security_types_catalog).and_return(registry)
        end

        it "produce response with ticks" do
          expect(response).to all(be_an(Dtn::Messages::Symbol::ByFilter))
        end

        context "have attributes"
        %i[request_id symbol listed_market_id security_type_id description].each do |attr|
          it { expect(response.last.public_send(attr)).to be_present }
        end

        it { expect { |b| subject.call(search_line: "42", &b) }.to yield_control }
      end
    end
  end
end
