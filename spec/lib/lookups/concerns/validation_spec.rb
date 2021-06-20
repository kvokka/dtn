# frozen_string_literal: true

module Dtn
  module Lookups
    module Concerns
      RSpec.describe Validation do
        let(:subject) do
          class Foo
            include Dtn::Lookups::Concerns::Validation
            public(*private_instance_methods) # rubocop:disable Style/AccessModifierDeclarations
          end.new
        end

        context "#validate_date" do
          context "valid" do
            ["20200101", Date.new(2020, 1, 1), "", nil].each do |value|
              it { expect { subject.validate_date(value) }.not_to raise_error }
            end
          end

          context "invalid" do
            ["2020", "20201301", "20200132", "ololo", :foo].each do |value|
              it { expect { subject.validate_datetime(value) }.to raise_error Request::ValidationError }
            end
          end

          context "returns" do
            it { expect(subject.validate_date("20200101")).to eq "20200101" }
            it { expect(subject.validate_date(Date.new(2020, 1, 1))).to eq "20200101" }
          end
        end

        context "#validate_datetime" do
          context "valid" do
            ["20200101 100000", Date.new(2020, 1, 1), DateTime.new(2020, 1, 1, 10, 0, 0), "", nil].each do |value|
              it { expect { subject.validate_datetime(value) }.not_to raise_error }
            end
          end

          context "invalid" do
            ["2020", "20201301", "20200132", "20200101 250000", "20200101 006100", "20200101 000061",
             "ololo", :foo].each do |value|
              it { expect { subject.validate_datetime(value) }.to raise_error Request::ValidationError }
            end
          end

          context "returns" do
            it { expect(subject.validate_datetime("20200101")).to eq "20200101 000000" }
            it { expect(subject.validate_datetime("20200101 111213")).to eq "20200101 111213" }
            it { expect(subject.validate_datetime(Date.new(2020, 1, 1))).to eq "20200101 000000" }
            it { expect(subject.validate_datetime(DateTime.new(2020, 1, 1, 10, 11, 12))).to eq "20200101 101112" }
          end
        end

        context "#validate_int" do
          context "valid" do
            [42, "1", 65_636].each do |value|
              it { expect { subject.validate_short_int(value) }.not_to raise_error }
            end
          end

          context "invalid" do
            ["5a", :foo, ""].each do |value|
              it { expect { subject.validate_short_int(value) }.to raise_error Request::ValidationError }
            end
          end

          context "returns" do
            it { expect(subject.validate_short_int("42")).to eq 42 }
            it { expect(subject.validate_short_int(42)).to eq 42 }
          end
        end

        context "#validate_short_int" do
          context "returns" do
            it { expect(subject.validate_short_int("42")).to eq 42 }
            it { expect(subject.validate_short_int(42)).to eq 42 }
            it { expect(subject.validate_short_int(65_536)).to eq 65_535 }
            it { expect(subject.validate_short_int(655_360)).to eq 65_535 }
          end
        end
      end
    end
  end
end
