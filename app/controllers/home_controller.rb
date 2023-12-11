# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    four_weeks_ago = 4.weeks.ago.beginning_of_week
    current_date = Time.zone.today.end_of_week

    @grouped_rates = CurrencyRate.where('EXTRACT(dow FROM date) = ?', 0)
                                 .where(date: four_weeks_ago..current_date)
                                 .order(:kind, :date)
                                 .group_by(&:kind)

    @date_rates = @grouped_rates.values.flatten.map(&:date).uniq
  end
end
