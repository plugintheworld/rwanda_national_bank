require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RwandaNationalBank::HistoricRates do
  DEC1_RATES = {
    'AED' => 202.026501,
    'AUD' => 536.399838,
    'BIF' => 0.476775,
    'CAD' => 555.32243,
    'CHF' => 721.358902,
    'CNY' => 115.98065,
    'DKK' => 105.076042,
    'EGP' => 94.768795,
    'ETB' => 35.429772,
    'EUR' => 783.951869,
    'GBP' => 1117.286319,
    'INR' => 11.165072,
    'JPY' => 6.028145,
    'KES' => 7.261081,
    'KMF' => 1.699323,
    'KPW' => 5.707945,
    'KRW' => 0.639287,
    'KWD' => 2434.966601,
    'LSL' => 51.361852,
    'LYD' => 527.784493,
    'MRO' => 2.341207,
    'MUR' => 20.406718,
    'MWK' => 1.235534,
    'NGN' => 3.725153,
    'NOK' => 85.307499,
    'RUB' => 11.205143,
    'SAR' => 197.770773,
    'SDG' => 121.854074,
    'SEK' => 85.040357,
    'SGD' => 526.010964,
    'SSP' => 267.14248,
    'SZL' => 51.347011,
    'TRY' => 254.750037,
    'TZS' => 0.342833,
    'UGX' => 0.221506,
    'USD' => 742.062444,
    'XAF' => 1.18359,
    'XDR' => 1018.963045,
    'XOF' => 1.176169,
    'ZAR' => 51.343301,
    'ZMW' => 71.609026,
    'ZWD' => 1.95904
   }

  let(:dec1) do
    bnr = RwandaNationalBank::HistoricRates.new as_of: Date.new(2015, 12, 1)
    allow(bnr).to receive(:scrape).and_return(DEC1_RATES)
    bnr
  end

  let(:future) do
    bnr = RwandaNationalBank::HistoricRates.new as_of: Date.new(2039, 2, 1)
    allow(bnr).to receive(:scrape).and_return({})
    bnr
  end

  describe '.import!' do
    it 'returns true when rates could be retrieved' do
      expect(dec1.import!).to be_truthy
    end

    it 'returns false when there are no rates' do
      expect(future.import!).to be_falsey
    end
  end

  describe '.currencies/.rates/.rate' do
    it 'throws an error when import! has not been called yet' do
      expect { dec1.rates }.to raise_error RwandaNationalBank::MissingRates
      expect { dec1.currencies }.to raise_error RwandaNationalBank::MissingRates
      expect { dec1.rate('ISO', 'ISO') }.to raise_error RwandaNationalBank::MissingRates
    end

    it 'throws an error when there are no rates' do
      future.import!
      expect { future.rates }.to raise_error RwandaNationalBank::MissingRates
      expect { future.currencies }.to raise_error RwandaNationalBank::MissingRates
      expect { future.rate('ISO', 'ISO') }.to raise_error RwandaNationalBank::MissingRates
    end
  end

  describe '.has_rates?' do
    it 'returns true when there are rates' do
      dec1.import!
      expect( dec1 ).to have_rates
    end

    it 'returns false when there are no rates' do
      expect( dec1 ).not_to have_rates
    end
  end

  describe '.rate' do
    it 'returns a specific rate' do
      dec1.import!
      expect(dec1.rate('RWF', 'EUR')).to eq 1/783.951869
    end

    it 'returns the inverse rate' do
      dec1.import!
      expect(dec1.rate('EUR', 'RWF')).to eq 783.951869
    end

    it 'returns nil when currency is not known' do
      dec1.import!
      expect(dec1.rate('XXX', 'RWF')).to be_nil
      expect(dec1.rate('XXX', 'XXX')).to be_nil
    end
  end

  describe '.currencies' do
    it 'returns an array' do
      dec1.import!
      expect(dec1.currencies).to eq DEC1_RATES.keys
    end
  end

  describe '.rates' do
    it 'returns all rates' do
      dec1.import!
      expect(dec1.rates).to eq DEC1_RATES
    end
  end

  describe '#scrape' do
    it 'returns an empty hash for future dates' do
      result = RwandaNationalBank::HistoricRates.scrape Date.new(2039, 2, 1)
      expect(result).to eq({})
    end

    it 'produces a hash with exchange rates' do
      result = RwandaNationalBank::HistoricRates.scrape Date.new(2015, 12, 1)
      expect(result).to eq DEC1_RATES
     end
  end
end
