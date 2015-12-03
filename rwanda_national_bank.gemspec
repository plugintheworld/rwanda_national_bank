Gem::Specification.new do |s|
  s.name         = 'rwanda_national_bank'
  s.version      = '0.1.0'
  s.platform     = Gem::Platform::RUBY
  s.date         = '2015-12-02'
  s.summary      = 'Retrieves historic RWF exchange rates from the BNR'
  s.description  = 'Wraps a simple scraper to retrieve the historic exchange rates for Rwandan Franc (RWF). Returns the average (between buy and sell) rates for any yesterday or any day specified and supported by the National Bank of Rwanda.'
  s.authors      = ['Christoph Peschel']
  s.email        = ['hi@chrp.es']
  s.homepage     = 'http://github.com/plugintheworld/rwanda_national_bank'
  s.license      = 'GPL'

  s.add_runtime_dependency 'nokogiri', '~> 1.6'
  s.add_development_dependency 'rspec', '~> 3.3'
  s.add_development_dependency 'nyan-cat-formatter'

  s.require_path = 'lib'
  s.files        = Dir.glob('lib/**/*') + %w(LICENSE README.md)
end
