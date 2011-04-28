$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'shoulda'

require 'active_record'
# Debug activerecord
# require 'logger'
# ActiveRecord::Base.logger = Logger.new(STDOUT)

# Load the schema
TEST_ROOT = File.expand_path(File.dirname(__FILE__))
$: << File.join(TEST_ROOT, 'lib')
load 'database.rb'

# Load the matchers
require File.dirname(__FILE__) + '/../shoulda_matchers/lincoln_matchers'

require 'lincoln'
