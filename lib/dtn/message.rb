# frozen_string_literal: true

module Dtn
  # Message abstraction
  class Message
    def initialize(line)
      @line = line
    end

    def call
      raise NotImplemented
    end

    def to_s
      line
    end

    protected

    attr_reader :line
  end
end
