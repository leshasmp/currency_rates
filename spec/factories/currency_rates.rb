# frozen_string_literal: true

FactoryBot.define do
  factory :currency_rate do
    date { Faker::Date.between(from: Time.zone.today, to: 1.year.from_now) }
    kind { CurrencyRate.kinds.values.sample }
    value { Faker::Number.between(from: 1, to: 100) }
  end
end
