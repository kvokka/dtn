# frozen_string_literal: true

module Dtn
  module Concerns
    # Id creation and management methods
    module Id
      extend ActiveSupport::Concern

      included do
        extend Forwardable
        delegate next_id: :"self.class"
      end

      class_methods do
        def next_id
          _id_tvar.increment
          last_id
        end

        def last_id
          _id_tvar.value
        end

        private

        def _id_tvar
          @_id_tvar ||= Concurrent::AtomicFixnum.new
        end
      end

      def id
        @id ||= next_id
      end
    end
  end
end
