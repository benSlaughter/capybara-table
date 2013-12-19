require 'coveralls'

Coveralls.wear!

require 'capybara-table'

RSpec.configure do |config|
  config.color_enabled  = true
  config.formatter      = :documentation
end
