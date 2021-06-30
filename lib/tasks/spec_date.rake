# frozen_string_literal: true

namespace :spec do
  desc "Use previous working day as a date for specs"
  task :set_spec_date do
    require "ext/business_day"

    day = 1.business_day.ago.to_date
    File.open("spec/current_day", "w") { |f| f.puts day }

    puts "Set #{day} as a spec working day"
  end
end
