# frozen_string_literal: true

module PercentageHelper
  def calculate_percentage(prev_value, next_value)
    return 0 if next_value == prev_value

    percentage = (((next_value.to_f - prev_value.to_f) / prev_value.to_f) * 100).to_i
    percentage.positive? ? "+#{percentage}" : percentage
  end
end
