# frozen_string_literal: true

module Dtn
  module Streaming
    module Clients
      # Quote provides real-time Level 1 data and real-time news.
      #
      # Quote provides access to top-of-book quotes, regional quotes
      # (quotes from a single exchange), fundamentals (which includes
      # reference) data, streaming real-time news.
      #
      # Quotes, Regional, Trades and Fundamental data is provided as a messages
      # since you are likely going to do something fancy with it.
      #
      #
      # READ THIS CAREFULLY: For quote updates (provided when the top of book
      # quote changes or a trade happens) IQFeed.exe can send dynamic fieldsets.
      # This means that you can ask for any fields (subset of the set available)
      # you want. This map to `Messages::Quote::Level1::ALL_FIELDS` which lists
      # all available fields which will be used as a field name by DTN.
      # The values corresponding to each
      # key a tuple of (FieldName used by DTN, FieldName used in Structured Array,
      # numpy scalar type used for that field).
      #
      # We start with a default set of fields (same as default in the IQFeed
      # docs. It will be fetch once client starts. If you want a different
      # set of fields, call
      # `client.request.quote.update_fields list: %i[Bid Ask]` with the
      # fieldnames you want. If you want a different set of fieldnames for options
      # and stocks, create two clients. Use one for all stock subscriptions and
      # one for all options subscriptions. They can both use the same observer if
      # that is what you want.
      #
      # If you don't understand the above two paragraphs, look at the code, look
      # at the examples, run the examples and then read the above again.
      class Quote < Client
        PORT = 5009

        SUPPORTED_MESSAGES = COMMON_SUPPORTED_MESSAGES.merge(
          "F" => Messages::Quote::Level1Fundamental,
          "P" => Messages::Quote::Level1Summary,
          "Q" => Messages::Quote::Level1Update,
          "R" => Messages::Quote::Level1Regional,
          "N" => Messages::Quote::Level1News
        ).freeze

        private

        def init_connection
          request.quote.set_client_name(name: name)
          request.quote.current_update_fieldnames
          request.quote.set_protocol
        end
      end
    end
  end
end
