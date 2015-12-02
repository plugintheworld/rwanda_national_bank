# Rwanda National Bank Historic Exchange Rates

Wraps a simple scraper to retrieve the historic exchange rates for Rwandan Franc (RWF). Returns
the average (between buy and sell) rates for any yesterday or any day specified and supported by the
National Bank of Rwanda.

## Install

Add this line to your application's Gemfile:

```ruby
  gem 'rwanda_national_bank'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
  $ gem install rwanda_national_bank
```

## Usage

### Initialize

```ruby
  xe = RwandaNationalBank::HistoricRates.new as_of: Date(2015, 10, 24)
  xe.import! # => true
```

``import!`` returns ``true`` if rates have been found. Might also throw HTTP errors.

### Retrieve a specific rate

```ruby
  xe.rate('RWF', 'EUR') # => 768.4235
```

Get all available currencies:

```ruby
  xe.currencies # => ['AED', 'SRL', 'USD', 'ZAR', … ]
```

Get all rates

```ruby
  xe.rates # => { 'NOK' => 105.556298, 'INR' => 13.619511, … }
```

## Legal

The author of this gem is not affiliated with the National Bank of Rwanda.

### License

GPLv3, see LICENSE file

### No Warranty

The Software is provided "as is" without warranty of any kind, either express or implied,
including without limitation any implied warranties of condition, uninterrupted use,
merchantability, fitness for a particular purpose, or non-infringement.

