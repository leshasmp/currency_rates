# frozen_string_literal: true

class TableChartsController < ApplicationController
  def index
    four_weeks_ago = 4.weeks.ago.beginning_of_week
    current_date = Time.zone.today.end_of_week

    @grouped_rates = CurrencyRate.where('EXTRACT(dow FROM date) = ?', 0)
                                 .where(date: four_weeks_ago..current_date)
                                 .order(:kind, :date)
                                 .group_by(&:kind)
  end
end
