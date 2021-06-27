# frozen_string_literal: true

module Dtn
  module Streaming
    module Clients
      RSpec.describe Quote, infinite_reads: true do
        let(:observer) { MessagesRecorderObserver.new }

        after do
          subject.stop
        end

        context "fetch level 1 summary", socket_recorder: "streaming level1 summary" do
          before do
            subject.observers << observer
            subject.request.quote.watch symbol: :aapl
            sleep(0.001) while observer.invoked_methods[:summary].empty?
          end

          it "should get level 1 summary" do
            expect(observer.invoked_methods[:summary]).to all(be_an(Dtn::Messages::Quote::Summary))
          end

          it "should receive all data in the message" do
            keys = observer.invoked_methods[:summary].first.to_h.keys.map(&:to_s)
            expect(Messages::Quote::Level1::ALL_FIELDS.keys).to include(*keys)
          end
        end

        context "fetch level 1 summary with custom fields", socket_recorder: "streaming level1 custom update" do
          before do
            subject.observers << observer
            subject.request.system.update_fields list: %i[Bid Ask]
            subject.request.quote.watch symbol: :aapl
            sleep(0.001) while observer.invoked_methods[:update].empty?
          end

          # # TODO: try this out in trading hours

          # it "should get level 1 update" do
          #   expect(observer.invoked_methods[:update]).to all(be_an(Dtn::Messages::Quote::Update))
          # end

          # it "should receive only filtered data" do
          #   keys = observer.invoked_methods[:update].first.to_h.keys
          #   expect(keys).to eq %i[Symbol Bid Ask]
          # end
        end
      end
    end
  end
end
