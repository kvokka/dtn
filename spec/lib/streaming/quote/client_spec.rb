# frozen_string_literal: true

module Dtn
  module Streaming
    module Clients
      RSpec.describe Quote, infinite_reads: true do
        let(:observer) { MessagesRecorderObserver.new }

        before do
          subject.observers << observer
        end

        after do
          subject.stop
        end

        unless ENV["SPEC_DEBUG"]
          around do |ex|
            Timeout.timeout(5) do
              ex.run
            end
          end
        end

        context "fetch level 1 summary", socket_recorder: "streaming level1 summary" do
          before do
            subject.request.quote.watch symbol: :aapl
            sleep(0.001) while observer.invoked_methods[:level1_summary].empty?
          end

          it "should get level 1 summary" do
            expect(observer.invoked_methods[:level1_summary]).to all(be_an(Dtn::Messages::Quote::Level1Summary))
          end

          it "should receive all data in the message" do
            keys = observer.invoked_methods[:level1_summary].first.to_h.keys.map(&:to_s)
            expect(Messages::Quote::Level1::ALL_FIELDS.keys).to include(*keys)
          end
        end

        context "fetch level 1 summary with custom fields", socket_recorder: "streaming level1 custom update" do
          before do
            subject.request.system.update_fields list: %i[Bid Ask]
            subject.request.quote.watch symbol: :aapl
            sleep(0.001) while observer.invoked_methods[:level1_update].empty?
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

        context "fundamental fieldnames", socket_recorder: "streaming fundamental fieldnames" do
          before do
            subject.request.system.fundamental_fieldnames
            sleep(0.001) while observer.invoked_methods[:fundamental_fieldnames].empty?
          end

          it "should include the list" do
            expect(
              observer.invoked_methods[:fundamental_fieldnames]
            ).to all(be_an(Dtn::Messages::System::Generic::FundamentalFieldnames))
          end

          it "should be a list" do
            expect(
              observer.invoked_methods[:fundamental_fieldnames].first.list
            ).to be_a Array
          end
        end

        context "all update fieldnames", socket_recorder: "streaming all update fieldnames" do
          before do
            subject.request.system.all_update_fieldnames
            sleep(0.001) while observer.invoked_methods[:all_update_fieldnames].empty?
          end

          it "should include the list" do
            expect(
              observer.invoked_methods[:all_update_fieldnames]
            ).to all(be_an(Dtn::Messages::System::Generic::AllUpdateFieldnames))
          end

          it "should be a list" do
            expect(
              observer.invoked_methods[:all_update_fieldnames].first.list
            ).to be_a Array
          end
        end

        context "current update fieldnames", socket_recorder: "streaming current update fieldnames" do
          before do
            subject.request.system.current_update_fieldnames
            sleep(0.001) while observer.invoked_methods[:current_update_fieldnames].empty?
          end

          it "should include the list" do
            expect(
              observer.invoked_methods[:current_update_fieldnames]
            ).to all(be_an(Dtn::Messages::System::Generic::CurrentUpdateFieldnames))
          end

          it "should be a list" do
            expect(
              observer.invoked_methods[:current_update_fieldnames].first.list
            ).to be_a Array
          end
        end

        context "level1 refresh", socket_recorder: "streaming level1 refresh" do
          before do
            # we must be subscribed to be able to refresh
            subject.request.quote.watch symbol: :aapl
            #  we must to wait at least 1 second on iqfeed side to refresh.
            sleep(0.001) while observer.invoked_methods[:timestamp].empty?
            subject.request.quote.refresh symbol: :aapl
            sleep(0.001) while (observer.invoked_methods[:level1_summary] || []).size < 2
          end

          it "should get level 1 summary twice" do
            expect(observer.invoked_methods[:level1_summary].size).to eq 2
          end
        end

        context "level1 watches", socket_recorder: "streaming level1 watches" do
          before do
            subject.request.quote.watch symbol: :aapl
            subject.request.system.watches
            sleep(0.001) while observer.invoked_methods[:watches].empty?
          end

          it "should watch the stock" do
            expect(observer.invoked_methods[:watches].first.list).to eq ["AAPL"]
          end
        end

        context "level1 unwatch", socket_recorder: "streaming level1 unwatch" do
          before do
            subject.request.quote.watch symbol: :aapl
            subject.request.quote.watch symbol: :fb
            subject.request.quote.unwatch symbol: :aapl
            subject.request.system.watches
            sleep(0.001) while observer.invoked_methods[:watches].empty?
          end

          it "should return empty watches" do
            expect(observer.invoked_methods[:watches].first.list).to eq ["FB"]
          end
        end

        context "level1 unwatch all", socket_recorder: "streaming level1 unwatch all" do
          before do
            subject.request.quote.watch symbol: :aapl
            subject.request.system.unwatch_all
            subject.request.system.watches
            sleep(0.001) while observer.invoked_methods[:watches].empty?
          end

          it "should return empty watches" do
            expect(observer.invoked_methods[:watches].first.list).to be_empty
          end
        end
      end
    end
  end
end
