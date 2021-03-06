# frozen_string_literal: true

module Dtn
  module Lookups
    RSpec.describe Request do
      context ".next_id" do
        it "produce next_id" do
          expect { described_class.next_id }.to change { described_class.last_id }.by(1)
        end
      end

      context ".last_id" do
        it { expect(described_class.last_id).to be_a Integer }
      end
    end
  end
end
