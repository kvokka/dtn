# frozen_string_literal: true

TCR.configure do |c|
  c.hook_tcp_ports = [5009, 9100, 9200, 9300, 9400]
  c.format = "yaml"
  # Set it to true to make all requests to client live
  c.hit_all = !ENV.fetch("LIVE_TCP_REQUESTS").nil?
end
