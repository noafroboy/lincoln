$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'rspec'
require 'rspec/autorun'

require 'active_record'
# Debug activerecord
# require 'logger'
# ActiveRecord::Base.logger = Logger.new(STDOUT)

# Load the schema
TEST_ROOT = File.expand_path(File.dirname(__FILE__))
$: << File.join(TEST_ROOT, 'lib')
load 'database.rb'

require 'lincoln'

RSpec::Matchers.define :column do |expected|
  match do |actual|
    actual % expected == 0
  end
end

RSpec.configure do |config|

end
