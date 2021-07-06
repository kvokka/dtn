# frozen_string_literal: true

module Dtn
  module Streaming
    module Clients
      RSpec.describe Level2, infinite_reads: true do
        include_context "streaming client preparations"
        let(:timeout) { 10 }

        context "watch level2", socket_recorder: "streaming level2 watch", require_realtime_data: true do
          before do
            subject.request.level2.watch symbol: :blin
            sleep(0.001) while observer.invoked_methods[:level2_update].empty?
          end

          it "receive client stats" do
            expect(observer.invoked_methods[:level2_update].size).to be_positive
          end
        end
      end
    end
  end
end
