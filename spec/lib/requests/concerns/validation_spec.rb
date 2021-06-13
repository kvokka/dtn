# frozen_string_literal: true

module Dtn
  module Requests
    module Concerns
      RSpec.describe Validation do
        let(:subject) do
          class Foo
            include Dtn::Requests::Concerns::Validation
            public(*private_instance_methods) # rubocop:disable Style/AccessModifierDeclarations
          end.new
        end

        context "#validate_date" do
          context "valid" do
            ["20200101", Date.new(2020, 1, 1)].each do |value|
              it { expect { subject.validate_date(value) }.not_to raise_error }
            end
          end

          context "invalid" do
            ["2020", "20201301", "20200132", "ololo", :foo, ""].each do |value|
              it { expect { subject.validate_datetime(value) }.to raise_error Date::Error }
            end
          end

          context "returns" do
            it { expect(subject.validate_date("20200101")).to eq "20200101" }
            it { expect(subject.validate_date(Date.new(2020, 1, 1))).to eq "20200101" }
          end
        end

        context "#validate_datetime" do
          context "valid" do
            ["20200101 100000", Date.new(2020, 1, 1), DateTime.new(2020, 1, 1, 10, 0, 0)].each do |value|
              it { expect { subject.validate_datetime(value) }.not_to raise_error }
            end
          end

          context "invalid" do
            ["2020", "20201301", "20200132", "20200101 250000", "20200101 006100", "20200101 000061",
             "ololo", :foo, ""].each do |value|
              it { expect { subject.validate_datetime(value) }.to raise_error Date::Error }
            end
          end

          context "returns" do
            it { expect(subject.validate_datetime("20200101")).to eq "20200101 000000" }
            it { expect(subject.validate_datetime("20200101 111213")).to eq "20200101 111213" }
            it { expect(subject.validate_datetime(Date.new(2020, 1, 1))).to eq "20200101 000000" }
            it { expect(subject.validate_datetime(DateTime.new(2020, 1, 1, 10, 11, 12))).to eq "20200101 101112" }
          end
        end
      end
    end
  end
end
