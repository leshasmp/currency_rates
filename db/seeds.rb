# frozen_string_literal: true

task prepare_database_and_fetch_currency_rates: :environment do
  current_date = Time.zone.today
  current_day_of_week = current_date.wday
  days_until_sunday = (current_day_of_week - 0) % 7
  last_or_current_sunday = current_date - days_until_sunday.days

  end_date = last_or_current_sunday
  start_date = end_date - 5.weeks + 1.day

  CurrencyRates::CreateByPeriodService.call(start_date, end_date)

  Rails.logger.debug 'Database is prepared, and currency rates data for the last month is fetched.'
end

Rake::Task['prepare_database_and_fetch_currency_rates'].invoke
