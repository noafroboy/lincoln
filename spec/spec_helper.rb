$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'rspec'
require 'rspec/autorun'

# Need to override ActivreRecord::Base before we require lincoln
# for testing
require 'active_record'
class ActiveRecord::Base
  def self.columns
    [ActiveRecord::ConnectionAdapters::Column.new("column1", nil, "string", false), 
      ActiveRecord::ConnectionAdapters::Column.new("column2", nil, "string", false), 
      ActiveRecord::ConnectionAdapters::Column.new("column3", nil, "string", false)]
  end
end
require 'lincoln'

RSpec.configure do |config|

end
