# frozen_string_literal: true

RSpec.describe Dtn do
  it "has a version number" do
    expect(Dtn::VERSION).not_to be nil
  end

  context "host" do
    it "has a host default host setting" do
      expect(Dtn.host).to eq "localhost"
    end
  end
end
