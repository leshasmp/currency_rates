# frozen_string_literal: true

require 'net/http'
require 'uri'

module Integrations
  module Crb
    class CurrencyRatesService
      URL = 'https://www.cbr.ru/scripts/'
      PATH = 'XML_daily.asp'
      RATES_CODE = %w[USD EUR CNY].freeze

      def self.call(date)
        new(date).call
      end

      def initialize(date)
        self.date = date
      end

      def call
        currency_rates
      end

      private

      attr_accessor :date

      def currency_rates
        uri = URI.join(URL, PATH)

        uri.query = "date_req=#{date.strftime('%d/%m/%Y')}"
        response = Net::HTTP.get_response(uri)

        doc = Nokogiri::XML(response.body)

        serialize(doc)
      end

      def serialize(doc)
        currencies = []

        RATES_CODE.each do |currency_code|
          value = doc.at_xpath("//Valute[CharCode='#{currency_code.upcase}']").at_css('Value').content

          data = {
            kind: currency_code.upcase,
            date:,
            value: BigDecimal(value.tr(',', '.'))
          }

          currencies.push data
        end

        currencies
      end
    end
  end
end
