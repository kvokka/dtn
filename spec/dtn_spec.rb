# frozen_string_literal: true

RSpec.describe Dtn do
  it "has a version number" do
    expect(Dtn::VERSION).not_to be nil
  end

  context "config" do
    it "has a host default setting" do
      expect(Dtn.config.host).to eq "localhost"
    end
  end
end
