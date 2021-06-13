# frozen_string_literal: true

module Dtn
  module Clients
    RSpec.describe Lookup do
      let(:date_range) { (CURRENT_DAY - 1.month)..CURRENT_DAY }
      let(:response) { subject.response.each_from_request(request_id: request_id).to_a }

      include_context "integration specs preparation"

      before do
        response
      end

      context "multiple requests" do
        subject { described_class.new auto_stop: false }

        context "news story" do
          let(:story_id) do
            req_id = subject.request.news.headline symbols: :aapl, date_range: date_range, limit: 1
            subject.response.each_from_request(request_id: req_id).to_a.first.story_id
          end

          context "text", socket_recorder: "news story text" do
            let(:request_id) do
              subject.request.news.story story_id: story_id
            end

            it "produce response with headlines" do
              expect(response).to all(be_an(Dtn::Messages::News::Story))
            end

            it "have correct combined_options" do
              expect(Request.registry.find(request_id).combined_options).to include(
                *%i[format_type id story_id deliver_to]
              )
            end

            it_behaves_like "request registered in registry as", Requests::News::Story

            context "have attributes"
            %i[request_id text].each do |attr|
              it { expect(response.last.public_send(attr)).to be_present }
            end
          end

          context "xml", socket_recorder: "news story xml" do
            let(:request_id) do
              subject.request.news.story story_id: story_id, format_type: "x"
            end

            it "produce response with headline" do
              expect(response).to all(be_an(Dtn::Messages::News::Story))
            end

            it "have correct combined_options" do
              expect(Request.registry.find(request_id).combined_options).to include(
                *%i[format_type id story_id deliver_to]
              )
            end

            it_behaves_like "request registered in registry as", Requests::News::Story

            context "have attributes"
            %i[request_id xml].each do |attr|
              it { expect(response.last.public_send(attr)).to be_present }
            end
          end
        end
      end

      context "single requests" do
        context "news config" do
          context "text", socket_recorder: "news config text" do
            let(:request_id) do
              subject.request.news.config
            end

            it "produce response with ticks" do
              expect(response).to all(be_an(Dtn::Messages::News::Config))
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
              expect(response).to all(be_an(Dtn::Messages::News::Config))
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
              expect(response).to all(be_an(Dtn::Messages::News::Headline))
            end

            it "have correct combined_options" do
              expect(Request.registry.find(request_id).combined_options).to include(
                *%i[format_type id symbols sources date_range limit]
              )
            end

            it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

            it_behaves_like "request registered in registry as", Requests::News::Headline

            context "have attributes"
            %i[request_id source story_id symbols timestamp text].each do |attr|
              it { expect(response.last.public_send(attr)).to be_present }
            end
          end

          context "xml", socket_recorder: "news headlines xml" do
            let(:request_id) do
              subject.request.news.headline limit: 10, symbols: :aapl, format_type: "x"
            end

            it "produce response with headline" do
              expect(response).to all(be_an(Dtn::Messages::News::Headline))
            end

            it "have correct combined_options" do
              expect(Request.registry.find(request_id).combined_options).to include(
                *%i[format_type id symbols sources date_range limit]
              )
            end

            it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

            it_behaves_like "request registered in registry as", Requests::News::Headline

            context "have attributes"
            %i[request_id xml].each do |attr|
              it { expect(response.last.public_send(attr)).to be_present }
            end
          end

          context "news story count" do
            context "text", socket_recorder: "news story count text" do
              let(:request_id) do
                subject.request.news.story_count symbols: :aapl, date_range: date_range
              end

              it "produce response with headlines" do
                expect(response).to all(be_an(Dtn::Messages::News::StoryCount))
              end

              it "have correct combined_options" do
                expect(Request.registry.find(request_id).combined_options).to include(
                  *%i[format_type id symbols date_range sources]
                )
              end

              it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

              it_behaves_like "request registered in registry as", Requests::News::StoryCount

              context "have attributes"
              %i[description count].each do |attr|
                it { expect(response.last.public_send(attr)).to be_present }
              end
            end

            context "xml", socket_recorder: "news story count xml" do
              let(:request_id) do
                subject.request.news.story_count symbols: :aapl, date_range: date_range, format_type: "x"
              end

              it "produce response with headline" do
                expect(response).to all(be_an(Dtn::Messages::News::StoryCount))
              end

              it "have correct combined_options" do
                expect(Request.registry.find(request_id).combined_options).to include(
                  *%i[format_type id symbols date_range sources]
                )
              end

              it("should stop engine in the end") { expect(subject.stopped?).to be_truthy }

              it_behaves_like "request registered in registry as", Requests::News::StoryCount

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
end
