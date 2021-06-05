# frozen_string_literal: true

TCR.configure do |c|
  c.hook_tcp_ports = [5009, 9100, 9200, 9300, 9400]
  c.format = "yaml"
  c.cassette_library_dir = "spec/fixtures/tcr_cassettes"
end
