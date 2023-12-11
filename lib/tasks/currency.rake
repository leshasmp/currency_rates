# frozen_string_literal: true

namespace :currency_rates do
  desc 'Create currency exchange rates'
  task create: :environment do
    CurrencyRates::CreateService.call
  end
end
