# frozen_string_literal: true

module Dtn
  # Message abstraction
  class Message < OpenStruct
    class << self
      def parse(**options)
        new(options)
      end

      def callback_name
        @callback_name ||= name.demodulize.underscore
      end
    end

    def callback_name
      self.class.callback_name
    end
  end

  # For messages which return a collection of comma separated values.
  class ParseListFromMessage < Message
    class << self
      def parse(line:, **)
        new list: line.chomp.split(",").uniq
      end
    end
  end
end
