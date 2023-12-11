# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CurrencyRates::CreateByPeriodService do
  subject(:call_service) { described_class.call(start_date, end_date) }

  let(:current_date) { Faker::Date.between(from: 1.year.ago, to: Time.zone.today) }
  let(:start_date) { current_date.end_of_month }
  let(:end_date) { start_date + 1.day }
  let(:created_usd_rates) { CurrencyRate.USD }
  let(:created_eur_rates) { CurrencyRate.EUR }
  let(:created_cny_rates) { CurrencyRate.CNY }
  let(:response_rates) do
    <<~XML
      <ValCurs Date="#{start_date.strftime('%d.%m.%Y')}" name="Foreign Currency Market">
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
    stub_request(:get, "https://www.cbr.ru/scripts/XML_daily.asp?date_req=#{start_date.strftime('%d/%m/%Y')}")
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Host' => 'www.cbr.ru'
        }
      )
      .to_return(status: 200, body: response_rates, headers: {})

    stub_request(:get, "https://www.cbr.ru/scripts/XML_daily.asp?date_req=#{end_date.strftime('%d/%m/%Y')}")
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Host' => 'www.cbr.ru'
        }
      )
      .to_return(status: 200, body: response_rates, headers: {})

    call_service
  end

  it 'create usd rates' do
    first_rate = created_usd_rates.first
    second_rate = created_usd_rates.last

    expect(first_rate.value).to eql(BigDecimal('91.6402'))
    expect(second_rate.value).to eql(BigDecimal('91.6402'))
    expect(first_rate.date.to_s).to eql(start_date.to_s)
    expect(second_rate.date.to_s).to eql(end_date.to_s)
  end

  it 'create eur rates' do
    first_rate = created_eur_rates.first
    second_rate = created_eur_rates.last

    expect(first_rate.value).to eql(BigDecimal('98.8409'))
    expect(second_rate.value).to eql(BigDecimal('98.8409'))
    expect(first_rate.date.to_s).to eql(start_date.to_s)
    expect(second_rate.date.to_s).to eql(end_date.to_s)
  end

  it 'create cny rates' do
    first_rate = created_cny_rates.first
    second_rate = created_cny_rates.last

    expect(first_rate.value).to eql(BigDecimal('12.7893'))
    expect(second_rate.value).to eql(BigDecimal('12.7893'))
    expect(first_rate.date.to_s).to eql(start_date.to_s)
    expect(second_rate.date.to_s).to eql(end_date.to_s)
  end
end
