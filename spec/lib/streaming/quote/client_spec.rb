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

        context "init", socket_recorder: "streaming init" do
          before do
            subject
            sleep(0.001) while observer.invoked_methods[:current_update_fieldnames].empty?
          end

          it "receive current protocol message" do
            expect(observer.invoked_methods[:current_protocol].size).to be_positive
          end

          it "receive current update filednames message" do
            expect(observer.invoked_methods[:current_update_fieldnames].size).to be_positive
          end

          it "set fieldnames to client" do
            expect(subject.quote_update_fields).to be_a Array
          end
        end

        context "timestamp", socket_recorder: "streaming timestamp" do
          before do
            subject.request.system.timestamp_switch turned_on: false
            subject.request.system.timestamp
            sleep(0.001) while observer.invoked_methods[:timestamp].empty?
          end

          it "receive a timestamp by request" do
            expect(observer.invoked_methods[:timestamp].size).to be_positive
          end
        end

        context "fetch level 1 summary", socket_recorder: "streaming level1 summary" do
          context "quotes" do
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

          context "fundamental" do
            before do
              subject.request.quote.watch symbol: :aapl
              sleep(0.001) while observer.invoked_methods[:level1_fundamental].empty?
            end

            it "should get level1_fundamental" do
              expect(
                observer.invoked_methods[:level1_fundamental]
              ).to all(be_an(Dtn::Messages::Quote::Level1Fundamental))
            end

            it "should receive all data in the message" do
              keys = observer.invoked_methods[:level1_fundamental].first.to_h.keys.map(&:to_s)
              expect(Messages::Quote::Level1::ALL_FUNDAMENTAL_FIELDS.keys).to include(*keys)
            end
          end
        end

        context "fetch level 1 summary with custom fields", socket_recorder: "streaming level1 custom update" do
          before do
            subject.request.system.update_fields list: %i[Bid Ask]
            subject.request.quote.watch symbol: :aapl
            sleep(0.001) while observer.invoked_methods[:level1_summary].empty?
          end

          it "should get level 1 update" do
            expect(observer.invoked_methods[:current_update_fieldnames].size).to be > 2
          end

          it "should receive only filtered data" do
            keys = observer.invoked_methods[:current_update_fieldnames].last.list
            expect(keys).to eq %w[Symbol Bid Ask]
          end
        end

        context "fetch level 1 update", socket_recorder: "streaming level1 update" do
          include_context "use recording or run in woking hours"

          before do
            subject.request.quote.watch symbol: :spy
            sleep(0.001) while observer.invoked_methods[:level1_update].empty?
          end

          it "should get level 1 update" do
            expect(observer.invoked_methods[:level1_update].size).to be_positive
          end
        end

        context "fetch level 1 regional update", socket_recorder: "streaming level1 regional update" do
          include_context "use recording or run in woking hours"

          before do
            subject.request.quote.watch symbol: :aapl
            subject.request.system.regional_switch symbol: :aapl
            sleep(0.001) while observer.invoked_methods[:level1_regional].empty?
          end

          it "should get level 1 regional" do
            expect(observer.invoked_methods[:level1_regional].size).to be_positive
          end
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

        context "level1 regional switch", socket_recorder: "streaming level1 regional switch" do
          before do
            subject.request.quote.watch symbol: :aapl
            subject.request.system.regional_switch symbol: :aapl
            sleep(0.001) while (observer.invoked_methods[:level1_summary] || []).size < 2
          end

          it "should get level1 summary message" do
            expect(observer.invoked_methods[:level1_summary].size).to eq 2
          end
        end

        context "level1 trades", socket_recorder: "streaming level1 trades" do
          before do
            subject.request.quote.trades symbol: :aapl
            sleep(0.001) while (observer.invoked_methods[:current_update_fieldnames] || []).size < 2
          end

          # in fact it should produce updates, but we can not test them at any time
          it "should get level1 summary message" do
            expect(observer.invoked_methods[:current_update_fieldnames].size).to eq 2
          end
        end
      end
    end
  end
end
