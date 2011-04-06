require File.dirname(__FILE__) + "/spec_helper"

describe "attr_reader" do
  it "has ignore_attributes" do
    MyModel.ignore_attributes.should == Set.new(["column1", "column2"])
  end
  
  it "ignores columns specified in ignore_attr" do
    column_names = MyModel.columns.collect { |column| column.name }
    column_names.should == ["column3"]
  end
end

class MyModel < ActiveRecord::Base
  attr_ignore :column1, :column2
end
