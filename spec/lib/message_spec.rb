# frozen_string_literal: true

module Dtn
  RSpec.describe Message do
    context ".parse" do
      let(:message_subclass) do
        Class.new(described_class) do
          def self.fields
            { name: :to_s, age: :to_i, dob: :to_datetime }
          end
        end
      end

      subject { message_subclass.parse(line: line) }

      context "valid data" do
        let(:line) { "nick,25,1999-01-01" }

        it("should be right class") { is_expected.to be_a message_subclass }
        it("should have right name") { expect(subject.name).to eq "nick" }
        it("should have right age") { expect(subject.age).to eq 25 }
        it("should have right dob") { expect(subject.dob).to eq "1999-01-01".to_datetime }
      end

      context "extra data" do
        let(:line) { "nick,25,1999-01-01,extra" }
        it("should omit extra data") { expect(subject.to_h.keys).to eq %i[name age dob] }
      end
    end
  end
end
