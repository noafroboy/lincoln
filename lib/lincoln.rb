require 'active_record'
require File.dirname(__FILE__) + "/lincoln/attr_ignore"

ActiveRecord::Base.send(:include, Lincoln::AttrIgnore)
