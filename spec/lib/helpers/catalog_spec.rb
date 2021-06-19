# frozen_string_literal: true

module Dtn
  module Helpers
    RSpec.describe Catalog do
      context "ListedMarkets", socket_recorder: "catalog listed markets" do
        subject { Dtn.listed_markets_catalog }

        include_examples "global catalog helper method for klass", Dtn::Messages::Catalog::ListedMarkets
      end

      context "NaicCodes", socket_recorder: "catalog naic codes" do
        subject { Dtn.naic_codes_catalog }

        include_examples "global catalog helper method for klass", Dtn::Messages::Catalog::NaicCodes
      end

      context "SecurityTypes", socket_recorder: "catalog security types" do
        subject { Dtn.security_types_catalog }

        include_examples "global catalog helper method for klass", Dtn::Messages::Catalog::SecurityTypes
      end

      context "SicCodes", socket_recorder: "catalog sic codes" do
        subject { Dtn.sic_codes_catalog }

        include_examples "global catalog helper method for klass", Dtn::Messages::Catalog::SicCodes
      end

      context "TradeConditions", socket_recorder: "catalog trade conditions" do
        subject { Dtn.trade_conditions_catalog }

        include_examples "global catalog helper method for klass", Dtn::Messages::Catalog::TradeConditions
      end
    end
  end
end
