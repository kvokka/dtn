# frozen_string_literal: true

require "dtn"
require "pry"
require "active_support/time"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups # deprecate after move to rspec 4
end

Dir["#{__dir__}/support/**/*.rb"].sort.each { |file| require file }

# This is generated with
#
#    $ be rake spec:set_spec_date
#
# to minimise specs files changing as much as possible
CURRENT_DAY = File.open("spec/current_day", "r").readline.chomp.to_datetime
