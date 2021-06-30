# frozen_string_literal: true

require "business_time"
require "holidays"

Holidays.between(2.years.ago, Date.today, :us).each do |holiday|
  BusinessTime::Config.holidays << holiday[:date]
end

BusinessTime::Config.beginning_of_workday = BusinessTime::ParsedTime.parse("9:30 am")
BusinessTime::Config.end_of_workday = BusinessTime::ParsedTime.parse("4:00 pm")
