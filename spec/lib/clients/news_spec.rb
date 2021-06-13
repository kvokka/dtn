# frozen_string_literal: true

module Dtn
  module Clients
    RSpec.describe Lookup do
      context "single requests" do
        include_context "integration specs preparation"

        before do
          response
        end

        let(:response) { subject.response.each_from_request(request_id: request_id).to_a }

        context "news config" do
          context "text", socket_recorder: "news config text" do
            let(:request_id) do
              subject.request.news.config
            end

            it "produce response with ticks" do
              expect(response).to all(be_an(Dtn::Messages::NewsConfig))
            end

            it "have correct combined_options" do
              expect(Request.registry.find(request_id).combined_options).to include(*%i[format_type id])
            end

            it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

            it_behaves_like "request registered in registry as", Requests::News::Config

            context "have attributes"
            %i[request_id type name auth_code icon_id].each do |attr|
              it { expect(response.last.public_send(attr)).to be_present }
            end
          end

          context "xml", socket_recorder: "news config xml" do
            let(:request_id) do
              subject.request.news.config format_type: "x"
            end

            it "produce response with ticks" do
              expect(response).to all(be_an(Dtn::Messages::NewsConfig))
            end

            it "have correct combined_options" do
              expect(Request.registry.find(request_id).combined_options).to include(*%i[format_type id])
            end

            it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

            it_behaves_like "request registered in registry as", Requests::News::Config

            context "have attributes"
            %i[request_id xml].each do |attr|
              it { expect(response.last.public_send(attr)).to be_present }
            end
          end
        end

        context "news headlines" do
          context "text", socket_recorder: "news headlines text" do
            let(:request_id) do
              subject.request.news.headline limit: 10, symbols: :aapl
            end

            it "produce response with headlines" do
              expect(response).to all(be_an(Dtn::Messages::NewsHeadline))
            end

            it "have correct combined_options" do
              expect(Request.registry.find(request_id).combined_options).to include(
                *%i[format_type id symbols sources date limit]
              )
            end

            it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

            it_behaves_like "request registered in registry as", Requests::News::Headline

            context "have attributes"
            %i[request_id source headline_id symbols timestamp text].each do |attr|
              it { expect(response.last.public_send(attr)).to be_present }
            end
          end

          context "xml", socket_recorder: "news headlines xml" do
            let(:request_id) do
              subject.request.news.headline limit: 10, symbols: :aapl, format_type: "x"
            end

            it "produce response with headline" do
              expect(response).to all(be_an(Dtn::Messages::NewsHeadline))
            end

            it "have correct combined_options" do
              expect(Request.registry.find(request_id).combined_options).to include(
                *%i[format_type id symbols sources date limit]
              )
            end

            it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

            it_behaves_like "request registered in registry as", Requests::News::Headline

            context "have attributes"
            %i[request_id xml].each do |attr|
              it { expect(response.last.public_send(attr)).to be_present }
            end
          end
        end
      end
    end
  end
end
