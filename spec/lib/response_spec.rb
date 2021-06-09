# frozen_string_literal: true

module Dtn
  RSpec.describe Response do
    let(:client) { instance_double "Client", running?: true, queue: queue }

    subject { described_class.new(client: client) }
    let(:result) { [] }

    context "#each" do
      context "fetch 3 items from queue" do
        let(:queue) { Queue.new << 1 << 2 << 3 << 4 }

        before do
          subject.each do |el|
            result << el
            break if el > 2
          end
        end

        it("should left 1 element") { expect(queue.size).to eq 1 }
        it("should collect right elements") { expect(result).to eq [1, 2, 3] }
      end
    end

    context "#each_from_request" do
      let(:queue) do
        Queue.new << msg1 << msg2 << msg3 << msg4 << msg5 << msg6
      end

      let(:msg1) { instance_double("Tick", request_id: 1, termination?: false) }
      let(:msg2) { instance_double("Tick", request_id: 2, termination?: false) }
      let(:msg3) { instance_double("Tick", request_id: 1, termination?: false) }
      let(:msg4) { instance_double("Tick", request_id: 1, termination?: false) }
      let(:msg5) { instance_double("EndOfMessageCharacters", request_id: 2, termination?: true) }
      let(:msg6) { instance_double("EndOfMessageCharacters", request_id: 1, termination?: true) }

      it "should return only request_id 1 messages" do
        expect(subject.each_from_request(request_id: 1).to_a).to eq [msg1, msg3, msg4]
      end

      it "should return only request_id 2 messages" do
        expect(subject.each_from_request(request_id: 2).to_a).to eq [msg2]
      end
    end
  end
end
