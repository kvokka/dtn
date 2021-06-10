# frozen_string_literal: true

module Dtn
  # Abstract thread safe registry
  class Registry
    include Enumerable
    extend Forwardable

    delegate delete: :@items,
             size: :@items,
             clear: :@items

    attr_reader :name

    def initialize(name:)
      @name  = name
      @items = Concurrent::Map.new
    end

    def clear
      @items.clear
    end

    def each(&block)
      @items.values.uniq.each(&block)
    end

    def find(item_name)
      @items.fetch(item_name)
    rescue KeyError => e
      raise key_error_with_custom_message(e, item_name)
    end

    alias [] find

    def register(name, item)
      return unless name

      @items[name] = item
    end

    alias []= register

    def registered?(name)
      @items.key?(name)
    end

    private

    def key_error_with_custom_message(key_error, item_name)
      message = key_error.message.sub("key not found", %(#{@name} not registered: "#{item_name}"))
      error = KeyError.new(message)
      error.set_backtrace(key_error.backtrace)
      error
    end
  end
end
