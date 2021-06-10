# frozen_string_literal: true

module Dtn
  RSpec.shared_examples_for "request registered in registry as" do |klass|
    context "registry" do
      it "was registered right request" do
        expect(Request.registry.find(request_id)).to be_a klass
      end

      it "registered request was finished" do
        expect(Request.registry.find(request_id).finished?).to be_truthy
      end
    end
  end
end
