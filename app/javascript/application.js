// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// import "@hotwired/turbo-rails"
// import "controllers"
// import * as bootstrap from "bootstrap"
import 'c3/c3.css';
import c3 from 'c3';

document.addEventListener('DOMContentLoaded', function () {
  const chartDataElement = document.getElementById('chart-data');
  const dateRates = JSON.parse(chartDataElement.getAttribute('data-date-rates'));
  const groupedRatesUSD = JSON.parse(chartDataElement.getAttribute('data-grouped-rates-usd'));
  const groupedRatesEUR = JSON.parse(chartDataElement.getAttribute('data-grouped-rates-eur'));
  const groupedRatesCNY = JSON.parse(chartDataElement.getAttribute('data-grouped-rates-cny'));

  var chart = c3.generate({
    data: {
      x: 'x',
      columns: [
        ['x', ...dateRates],
        ['usd', ...groupedRatesUSD],
        ['eur', ...groupedRatesEUR],
        ['cny', ...groupedRatesCNY]
      ]
    },
    axis: {
      x: {
        type: 'timeseries',
        tick: {
          format: '%Y-%m-%d'
        }
      }
    }
  });
});
