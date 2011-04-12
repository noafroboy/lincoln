$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'rspec'
require 'rspec/autorun'

# Load the schema
require 'active_record'
TEST_ROOT = File.expand_path(File.dirname(__FILE__))
$: << File.join(TEST_ROOT, 'lib')
load 'database.rb'

require 'lincoln'

RSpec.configure do |config|

end
