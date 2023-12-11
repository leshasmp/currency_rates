# frozen_string_literal: true

module CurrencyRates
  class CreateByPeriodService
    def self.call(start_date, end_date)
      new(start_date, end_date).call
    end

    def initialize(start_date, end_date)
      self.start_date = start_date
      self.end_date = end_date
    end

    def call
      current_date = start_date

      while current_date <= end_date
        CreateService.call(current_date)

        current_date += 1.day
      end
    end

    private

    attr_accessor :start_date, :end_date
  end
end
