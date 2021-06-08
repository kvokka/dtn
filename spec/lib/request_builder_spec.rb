# frozen_string_literal: true

module Dtn
  RSpec.describe RequestBuilder do
    # rubocop:disable Lint/ConstantDefinitionInBlock
    before(:context) do
      module ::Dtn
        module Requests
          module Foo
            class MyRequest < Request
              def call(*args, **opts)
                [args, opts]
              end
            end
          end
        end
      end
    end
    # rubocop:enable Lint/ConstantDefinitionInBlock

    after(:context) do
      Dtn::Requests::Foo.send(:remove_const, :MyRequest)
      Dtn::Requests.send(:remove_const, :Foo)
    end

    let(:socket) { instance_double "TCPSocket" }
    subject { described_class.new(socket: socket) }

    context "#method_missing" do
      it "should return Proxy for foo class" do
        expect(subject.foo).to be_a described_class::Proxy
      end

      it "should raise for missing class" do
        expect { subject.some_really_missing_method }.to raise_error NoMethodError
      end

      context "Proxy" do
        it "should run #call method with correct arguments" do
          expect(subject.foo.my_request(:bar, a: 42)).to eq [[:bar], { a: 42 }]
        end

        it "should raise for missing class" do
          expect { subject.foo.some_really_missing_method }.to raise_error NoMethodError
        end
      end
    end
  end
end
