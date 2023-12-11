# frozen_string_literal: true

class CurrencyRate < ApplicationRecord
  include PercentageHelper

  KIND_ENUM_VALUES = %w[USD
                        EUR
                        CNY].freeze

  validates :kind, :date, :value, presence: true
  validates :date, uniqueness: { scope: :kind }

  enum :kind, KIND_ENUM_VALUES

  def percentage_increase
    next_currency = CurrencyRate.public_send(kind).select(:value).find_by(date: date - 6.days)

    calculate_percentage(value, next_currency.value)
  end
end
