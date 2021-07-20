# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup # ready!

require "forwardable"
require "concurrent/atomic/atomic_fixnum"
require "concurrent/map"
require "active_support/concern"
require "active_support/inflector"
require "active_support/core_ext/string"
require "active_support/time_with_zone"
require "socket"
require "securerandom"
require "ostruct"
require "date"

# Top level API methods only
module Dtn
  class Error < StandardError; end

  class ValidationError < Error; end

  extend Helpers::Catalog

  mattr_accessor :host, instance_accessor: false, default: ENV.fetch("DTN_HOST", "localhost")
end
