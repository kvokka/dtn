# frozen_string_literal: true

# A sample class, which will record all messages, which were
# invoked by the client
#
# In contrast with the spies it record all invocations for simpler
# further analyses
class MessagesRecorderObserver
  def invoked_methods
    @invoked_methods ||= Hash.new { |h, k| h[k] = [] }
  end

  def method_missing(method_name, **opts)
    invoked_methods[method_name] << opts[:message]
  end

  def respond_to_missing?(*)
    true
  end
end
