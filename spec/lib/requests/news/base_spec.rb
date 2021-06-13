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

        context "#validate_news_format_type" do
          context "valid" do
            ["x", "XML", "T", "tEXt", :t, nil].each do |value|
              it { expect { subject.validate_news_format_type(value) }.not_to raise_error }
            end
          end
          context "invalid" do
            %w[a foo].each do |value|
              it { expect { subject.validate_news_format_type(value) }.to raise_error Request::ValidationError }
            end
          end
          context "returns" do
            it { expect(subject.validate_news_format_type(nil)).to eq "t" }
            it { expect(subject.validate_news_format_type(:t)).to eq "t" }
            it { expect(subject.validate_news_format_type("XmL")).to eq "x" }
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

        context "#validate_date_range" do
          context "valid" do
            %w[20191007 20191001-20191007 20191001:20191007 20190612:20191001-20191007
               20190601-20190607:20191001-20191007
               20190601-20190607:20191001-20191007:20201001-20201007].each do |value|
              it { expect { subject.validate_date_range(value) }.not_to raise_error }
            end
          end

          context "invalid" do
            context "pair"
            %w[20191001- -20191007 20191001:20191007-].each do |value|
              it { expect { subject.validate_date_range(value) }.to raise_error Request::ValidationError }
            end

            context "date"
            %w[20191055 20191001-20191055 20190601-20190607:20191001-20191055].each do |value|
              it { expect { subject.validate_date_range(value) }.to raise_error Request::ValidationError }
            end
          end

          context "returns" do
            it { expect(subject.validate_date_range("")).to eq "" }
            it { expect(subject.validate_date_range(nil)).to eq nil }
          end
        end
      end
    end
  end
end
