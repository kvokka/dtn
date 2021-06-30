# frozen_string_literal: true

module Dtn
  module Messages
    module Quote
      # Streaming level1 news update.
      class Level1News < MessageWithSimpleParser
        class << self
          def fields
            @fields ||= {
              _skip: :nil,
              distributor: :to_s,
              story_id: :to_i,
              symbols_list: :to_s,
              story_datetime: :to_datetime,
              headline: :to_s
            }
          end
        end

        def after_initialization
          self.symbols_list = symbols_list.to_s.split(":").delete_if(&:blank?).uniq
        end
      end
    end
  end
end
