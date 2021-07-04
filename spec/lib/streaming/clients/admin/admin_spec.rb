# frozen_string_literal: true

module Dtn
  module Streaming
    module Clients
      RSpec.describe Admin, infinite_reads: true do
        include_context "streaming client preparations"

        context "set_client_stats", socket_recorder: "streaming admin set_client_stats" do
          before do
            subject.request.admin.set_client_stats
            sleep(0.001) while observer.invoked_methods[:client_stats].empty?
          end

          it "receive client stats" do
            expect(observer.invoked_methods[:client_stats].size).to be_positive
          end
        end

        context "stats", socket_recorder: "streaming admin stats" do
          before do
            subject
            sleep(0.001) while observer.invoked_methods[:stats].empty?
          end

          it "receive client stats" do
            expect(observer.invoked_methods[:stats].size).to be_positive
          end
        end
      end
    end
  end
end
