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

  RSpec.shared_context "integration specs preparation" do
    before do
      Request.registry.clear
      allow(Request).to receive(:next_id).and_return(1, 2, 3, 4, 5)
      # we must fetch all the data first for every request, cos the requests may run in different order
      request_id
    end

    after do
      subject.stop
    end

    unless ENV["DEBUG"]
      around do |example|
        Timeout.timeout(5) do
          example.run
        end
      end
    end
  end
end
