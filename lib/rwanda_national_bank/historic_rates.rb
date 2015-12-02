require 'nokogiri'
require 'uri'
require 'net/http'
require 'date'

module RwandaNationalBank
  class MissingRates < StandardError; end

  class HistoricRates
    attr_reader :as_of

    def initialize options = {}
      @as_of = options[:as_of] || Date.yesterday
    end

    def rate(iso_from, iso_to)
      fail MissingRates unless has_rates?

      if iso_from == 'RWF'
        rates[iso_to] ? 1/rates[iso_to] : nil
      elsif iso_to == 'RWF'
        rates[iso_from]
      else
        nil
      end
    end

    # Returns a list of ISO currencies
    def currencies
      fail MissingRates unless has_rates?
      @rates.keys
    end

    # Returns all rates returned
    def rates
      fail MissingRates unless has_rates?
      @rates
    end

    # Returns true when reading the website was successful
    def has_rates?
      !@rates.nil? && !@rates.empty?
    end

    # Triggers the srcaping
    def import!
      @rates = scrape(@as_of)
      has_rates?
    end

    def scrape as_of
      self.class.scrape(@as_of)
    end

    # Scrapes the RNB website for the historic exchange rates of a given day
    def self.scrape as_of
      # POST /index.php?id=384
      uri = URI('http://www.bnr.rw/index.php?id=384')

      # fday=30&fmonth=NOV&fyear=2015&history=Get+History
      params = {
        'fday'    => as_of.strftime('%d'),
        'fmonth'  => as_of.strftime('%b').upcase,
        'fyear'   => as_of.strftime('%Y'),
        'history' => 'Get History'
      }

      response = Net::HTTP.post_form(uri, params)
      dom = Nokogiri::HTML(response.body)
      rows = dom.css('#middlebar > table > tr') # will always return an []

      # RNB does not really use ISO codes thoroughly so we have to map some of their symbols
      translate_currency_symbols = {
        'KD' => 'KWD', # Kuwait Dinar
        'RS' => 'INR', # Indian Rupees
        'LD' => 'LRD' # Lybian Dinar
      }

      Hash[rows.map do |row|
        currency = row.css(':nth-child(1) > a').text
        next if currency.empty?
        avrg = row.css(':nth-child(4)').text
        next if avrg.empty?

        # translate currency to ISO symbol
        currency = translate_currency_symbols[currency.upcase] || currency

        [currency, Float(avrg)] rescue nil
      end.compact]
    end
  end
end
