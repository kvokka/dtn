# frozen_string_literal: true

module Dtn
  module Requests
    module System
      # Abstract base request
      class Base < Request
        def id; end
      end
    end
  end
end
