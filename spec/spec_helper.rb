require 'simplecov'
kettle = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(kettle) unless $LOAD_PATH.include?(kettle)

def fixture_path
  File.expand_path(File.join(__FILE__, '..', 'fixtures'))
end

RSpec.configure do |c|
  c.formatter = 'documentation'
  c.color = true
end

SimpleCov.start
