# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CurrencyRates::CreateService do
  subject(:call_service) { described_class.call(current_date) }

  let(:current_date) { Date.current }
  let(:created_usd_rates) { CurrencyRate.USD.last }
  let(:created_eur_rates) { CurrencyRate.EUR.last }
  let(:created_cny_rates) { CurrencyRate.CNY.last }

  let(:response_usd_rates) do
    <<~XML
      <ValCurs Date="#{current_date.strftime('%d.%m.%Y')}" name="Foreign Currency Market">
        <Valute ID="R01235">
          <NumCode>840</NumCode>
          <CharCode>USD</CharCode>
          <Nominal>1</Nominal>
          <Name>Доллар США</Name>
          <Value>91,6402</Value>
          <VunitRate>91,6402</VunitRate>
        </Valute>
        <Valute ID="R01239">
          <NumCode>978</NumCode>
          <CharCode>EUR</CharCode>
          <Nominal>1</Nominal>
          <Name>Евро</Name>
          <Value>98,8409</Value>
          <VunitRate>98,8409</VunitRate>
        </Valute>
        <Valute ID="R01375">
          <NumCode>156</NumCode>
          <CharCode>CNY</CharCode>
          <Nominal>1</Nominal>
          <Name>Китайский юань</Name>
          <Value>12,7893</Value>
          <VunitRate>12,7893</VunitRate>
        </Valute>
      </ValCurs>
    XML
  end

  before do
    stub_request(:get, "https://www.cbr.ru/scripts/XML_daily.asp?date_req=#{current_date.strftime('%d/%m/%Y')}")
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Host' => 'www.cbr.ru'
        }
      )
      .to_return(status: 200, body: response_usd_rates, headers: {})
  end

  context 'when currency rates is not created' do
    before { call_service }

    it 'create usd rate' do
      expect(created_usd_rates.value).to eql(BigDecimal('91.6402'))
      expect(created_usd_rates.date.to_s).to eql(current_date.to_s)
    end

    it 'create eur rate' do
      expect(created_eur_rates.value).to eql(BigDecimal('98.8409'))
      expect(created_eur_rates.date.to_s).to eql(current_date.to_s)
    end

    it 'create cny rate' do
      expect(created_cny_rates.value).to eql(BigDecimal('12.7893'))
      expect(created_cny_rates.date.to_s).to eql(current_date.to_s)
    end
  end

  context 'when currency rates already created' do
    before do
      create(:currency_rate, kind: 'USD', date: current_date)
      create(:currency_rate, kind: 'EUR', date: current_date)
      create(:currency_rate, kind: 'CNY', date: current_date)
    end

    it 'is invalid' do
      expect do
        call_service
      end.to raise_error(ActiveRecord::RecordInvalid, /Validation failed: Date has already been taken/)
    end
  end
end
