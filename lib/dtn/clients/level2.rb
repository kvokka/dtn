# frozen_string_literal: true

module Dtn
  module Clients
    # Level2 management methods only
    class Level2 < Client
      setting :port, 9200
    end
  end
end
