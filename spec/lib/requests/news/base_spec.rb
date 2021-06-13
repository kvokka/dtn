# frozen_string_literal: true

module Dtn
  module Requests
    module News
      RSpec.describe Base do
        let(:socket) { instance_double "TCPSocket" }
        let(:subject) do
          class Foo < described_class
            public(*private_instance_methods) # rubocop:disable Style/AccessModifierDeclarations
          end.new(socket: socket)
        end

        context "#validate_format_type" do
          context "valid" do
            ["x", "XML", "T", "tEXt", :t, nil].each do |value|
              it { expect { subject.validate_format_type(value) }.not_to raise_error }
            end
          end
          context "invalid" do
            %w[a foo].each do |value|
              it { expect { subject.validate_format_type(value) }.to raise_error Request::ValidationError }
            end
          end
          context "returns" do
            it { expect(subject.validate_format_type(nil)).to eq nil }
            it { expect(subject.validate_format_type(:t)).to eq "t" }
            it { expect(subject.validate_format_type("XmL")).to eq "x" }
          end
        end

        context "#validate_list" do
          context "valid" do
            ["aapl", "a;m;c", %w[a m c]].each do |value|
              it { expect { subject.validate_list(value) }.not_to raise_error }
            end
          end
          context "returns" do
            it { expect(subject.validate_list("aapl")).to eq "aapl" }
            it { expect(subject.validate_list(%w[aapl m])).to eq "aapl;m" }
          end
        end

        context "#validate_date_ranges" do
          context "valid" do
            %w[20191007 20191001-20191007 20191001:20191007 20190612:20191001-20191007
               20190601-20190607:20191001-20191007
               20190601-20190607:20191001-20191007:20201001-20201007].each do |value|
              it { expect { subject.validate_date_ranges(value) }.not_to raise_error }
            end
          end

          context "invalid" do
            context "pair"
            %w[20191001- -20191007 20191001:20191007-].each do |value|
              it { expect { subject.validate_date_ranges(value) }.to raise_error Request::ValidationError }
            end

            context "date"
            %w[20191055 20191001-20191055 20190601-20190607:20191001-20191055].each do |value|
              it { expect { subject.validate_date_ranges(value) }.to raise_error Request::ValidationError }
            end
          end

          context "returns" do
            {
              "" => "",
              nil => "",
              [(Date.new(2020, 1, 1)..Date.new(2020, 1, 15))] => "20200101-20200115",
              [Date.new(2020, 1, 1), Date.new(2020, 1, 15)] => "20200101:20200115",
              [(Date.new(2020, 1, 1)..Date.new(2020, 1, 5)), "20201101"] => "20200101-20200105:20201101",
              "20200101-20200105:20201101" => "20200101-20200105:20201101"
            }.each do |given, want|
              it { expect(subject.validate_date_ranges(*Array(given))).to eq want }
            end
          end
        end
      end
    end
  end
end
