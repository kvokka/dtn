# frozen_string_literal: true

module Dtn
  module Requests
    module Catalog
      # Catalog data from the client which is used for symbols lookup and
      # output description
      class Base < Request
        PORT = 9100
      end
    end
  end
end
