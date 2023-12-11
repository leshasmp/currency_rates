# frozen_string_literal: true

module CurrencyRates
  class CreateService
    def self.call(date)
      new(date).call
    end

    def initialize(date)
      self.date = date
    end

    def call
      currency_rates = Integrations::Crb::CurrencyRatesService.call(date)

      ActiveRecord::Base.transaction do
        currency_rates.each do |rate|
          CurrencyRate.create!(rate)
        end
      end
    end

    private

    attr_accessor :date
  end
end
