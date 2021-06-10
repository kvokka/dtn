# frozen_string_literal: true

module Dtn
  RSpec.describe Response do
    let(:client) { instance_double "Dtn::Client", running?: true, queue: queue }

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

      context "empty queue" do
        let(:queue) { Queue.new }

        before do
          # Did not find the better way to turn off the client
          allow(subject).to receive(:sleep) {
                              client.instance_eval do
                                def running?
                                  false
                                end
                              end
                            }
        end

        it "should sleep" do
          subject.each {} # rubocop:disable Lint/EmptyBlock
          expect(subject).to have_received(:sleep)
        end
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

      context "request_id 1" do
        let(:queue) { Queue.new << msg1 << msg3 << msg4 << msg6 }

        it "should return only own messages" do
          expect(subject.each_from_request(request_id: 1).to_a).to eq [msg1, msg3, msg4]
        end
      end

      context "request_id 2" do
        let(:queue) { Queue.new << msg2 << msg5 }

        it "should return only own messages" do
          expect(subject.each_from_request(request_id: 2).to_a).to eq [msg2]
        end
      end

      context "mixed requests" do
        let(:queue) { Queue.new << msg1 << msg2 }

        it "should raise" do
          expect do
            subject.each_from_request(request_id: 1).to_a
          end.to raise_error Response::MessageFromAnotherRequestError
        end
      end
    end
  end
end
