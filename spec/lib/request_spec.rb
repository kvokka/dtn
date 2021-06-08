# frozen_string_literal: true

module Dtn
  RSpec.describe Request do
    context ".next_id" do
      it "produce next_id" do
        expect { described_class.next_id }.to change { described_class.last_id }.by(1)
      end
    end

    context ".last_id" do
      it { expect(described_class.last_id).to be_a Integer }
    end

    context ".registry" do
      it { expect(described_class.registry).to be_a Registry }
    end
  end
end
