# frozen_string_literal: true

module Dtn
  RSpec.shared_examples_for "common historical tick" do |_klass|
    let(:response) { subject.call(**request_options) }

    it "produce response with ticks" do
      expect(response).to all(be_an(Dtn::Messages::Historical::Tick))
    end

    it { expect { |b| subject.call(**request_options, &b) }.to yield_control }

    context "have attributes" do
      %i[request_id
         timestamp
         last
         last_size
         total_volume
         bid
         ask
         tick_id
         basis_for_last
         trade_market_center
         trade_aggressor].each do |attr|
        it { expect(response.last.public_send(attr)).to be_present }
      end
    end
  end

  RSpec.shared_examples_for "common historical interval" do |_klass|
    let(:response) { subject.call(**request_options) }

    it "produce response with ticks" do
      expect(response).to all(be_an(Dtn::Messages::Historical::Interval))
    end

    it { expect { |b| subject.call(**request_options, &b) }.to yield_control }

    context "have attributes" do
      %i[request_id
         timestamp
         high
         low
         open
         close
         total_volume
         period_volume
         number_of_trades].each do |attr|
        it { expect(response.last.public_send(attr)).to be_present }
      end
    end
  end

  RSpec.shared_examples_for "common historical daily weekley monthly" do |_klass|
    let(:response) { subject.call(**request_options) }

    it "produce response with ticks" do
      expect(response).to all(be_an(Dtn::Messages::Historical::DailyWeeklyMonthly))
    end

    it { expect { |b| subject.call(**request_options, &b) }.to yield_control }

    context "have attributes" do
      %i[request_id
         timestamp
         high
         low
         open
         close
         period_volume
         open_interest].each do |attr|
        it { expect(response.last.public_send(attr)).to be_present }
      end
    end
  end

  RSpec.shared_examples_for "global catalog helper method for klass" do |klass|
    let(:desired_messages_class) { klass }
    let(:registry) { instance_double("Dtn::Registry", :[]= => nil) }

    it { is_expected.to be_a Registry }

    it "store the value in the variable" do
      allow(Registry).to receive(:new).and_return(registry)
      subject
      subject
      expect(Registry).to have_received(:new).at_most(1).time
    end

    it "contain right messages" do
      expect(subject).to all(be_an(desired_messages_class))
    end
  end

  RSpec.shared_context "use recording or run in woking hours" do
    before do
      require "ext/business_day" unless defined?(BusinessTime)
      next if Thread.current[:current_spec_cassette].persisted? ||
              Time.use_zone("Eastern Time (US & Canada)") { Time.zone.now.during_business_hours? }

      skip
    end
  end
end
