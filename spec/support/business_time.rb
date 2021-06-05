# frozen_string_literal: true

require "business_time"
require "holidays"

Holidays.between(2.years.ago, Date.today, :us).each do |holiday|
  BusinessTime::Config.holidays << holiday[:date]
end

TESTING_BUSINESS_DAY = 1.business_day.ago
