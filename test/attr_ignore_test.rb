require File.dirname(__FILE__) + "/test_helper"

class AttrIgnoreTest < Test::Unit::TestCase
  def setup
    create_my_models
  end
  
  should "have ignore_attributes" do
    assert_equal Set.new(["column1", "column2"]), MyModel.ignore_attributes
  end
  
  should "ignore columns specified in ignore_attr" do
    column_names = MyModel.columns.collect { |column| column.name }
    assert_equal ["id", "column3"], column_names
  end
end

class MyModel < ActiveRecord::Base
  attr_ignore :column1, :column2
end
