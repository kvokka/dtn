# frozen_string_literal: true

require "business_time"
require "holidays"

Holidays.between(2.years.ago, Date.today + 1, :us).each do |holiday|
  BusinessTime::Config.holidays << holiday[:date]
end

# Some dates might be manually moved by government, so we should update the the
# settings accordingly
BusinessTime::Config.holidays << Date.new(2021, 7, 5)

BusinessTime::Config.beginning_of_workday = BusinessTime::ParsedTime.parse("9:30 am")
BusinessTime::Config.end_of_workday = BusinessTime::ParsedTime.parse("4:00 pm")
