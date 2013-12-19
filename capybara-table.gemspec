lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capybara-table/version'

Gem::Specification.new do |spec|
  spec.name         = 'capybara-table'
  spec.summary      = 'HTML Table parsing for Capybara'
  spec.description  = 'Parse and sort HTML table using Capybara, in a simple to use table object'
  spec.homepage     = 'http://benslaughter.github.io/capybara-table/'
  spec.version      = Table::VERSION
  spec.date         = Table::DATE
  spec.license      = 'MIT'

  spec.author       = 'Ben Slaughter'
  spec.email        = 'b.p.slaughter@gmail.com'

  spec.files        = ['README.md', 'LICENSE', 'HISTORY.md']
  spec.files        += Dir.glob("lib/**/*.rb")
  spec.files        += Dir.glob("spec/**/*")
  spec.test_files   = Dir.glob("spec/**/*")
  spec.require_path = 'lib'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'selenium-webdriver'

  spec.add_runtime_dependency 'capybara'
  spec.add_runtime_dependency 'hashie'

end