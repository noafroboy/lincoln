require File.dirname(__FILE__) + "/test_helper"

class ChangeTableTest < Test::Unit::TestCase
  def setup
    create_my_models
  end
  
  should "add columns" do
    MyModelsAddColumn.up
    MyModel.reset_column_information
    
    assert_column MyModel, "column4", :type => :string
    assert_index MyModel, "column2"
    
    assert_column MyModel, "created_at"
    assert_column MyModel, "updated_at"
    
    assert_column MyModel, "column5", :type => :string
    assert_column MyModel, "column6", :type => :text
    assert_column MyModel, "column7", :type => :integer
    assert_column MyModel, "column8", :type => :float
    assert_column MyModel, "column9", :type => :integer, :precision => 10
    assert_column MyModel, "column10", :type => :datetime
    assert_column MyModel, "column11", :type => :datetime
    assert_column MyModel, "column12", :type => :time
    assert_column MyModel, "column13", :type => :date
    assert_column MyModel, "column14", :type => :binary
    assert_column MyModel, "column15", :type => :boolean
    
    assert_column MyModel, "model1_id", :type => :integer
    assert_column MyModel, "model2_id", :type => :integer
    assert_column MyModel, "model2_type", :type => :string
  end
  
  should "remove columns" do
    MyModelsAddColumn.up
    MyModelsRemoveColumn.up
    MyModel.reset_column_information
    
    assert_no_column MyModel, "column1"
    assert_no_index MyModel, "column2"
    assert_no_column MyModel, "created_at"
    assert_no_column MyModel, "updated_at"
    assert_no_column MyModel, "model1_id"
    assert_no_column MyModel, "model2_id"
    assert_no_column MyModel, "model2_type"
  end
  
  should "changes columns" do
    MyModelsAddColumn.up
    MyModelsChangeColumn.up
    MyModel.reset_column_information
    
    assert_no_column MyModel, "column4"
    assert_column MyModel, "column40"
    assert_column MyModel, "column3", :default => 'default'
    assert_column MyModel, "column3", :limit => 20
  end
  
  private
  
  def assert_index(klass, column)
    indexes = klass.connection.indexes(klass.table_name).find_all do |index|
      index.columns == [column.to_s]
    end
    assert_equal 1, indexes.size
  end
  
  def assert_no_index(klass, column)
    indexes = klass.connection.indexes(klass.table_name).find_all do |index|
      index.columns == [column.to_s]
    end
    assert_equal 0, indexes.size
  end
  
  # MyModel.should have_column("column2").with_type("string").with_default
  def assert_column(klass, name, options = {})
    type = options[:type]
    precision = options[:precision]
    default = options[:default]
    limit = options[:limit]
    
    columns = klass.columns.find_all { |c| c.name == name.to_s }
    assert_equal 1, columns.size
    
    column = columns.first
    options.each_pair do |option, value|
      assert_equal value.to_s, column.send(option).to_s
    end
  end
  
  def assert_no_column(klass, name)
    columns = klass.columns.find_all { |c| c.name == name.to_s }
    assert_equal 0, columns.size
  end
end

class MyModel < ActiveRecord::Base
end

class MyModelsAddColumn < ActiveRecord::Migration
  def self.up
    change_table(:my_models) do |t|
      t.index :column2
      
      t.column :column4, :string
      t.string :column5
      t.text :column6
      t.integer :column7
      t.float :column8
      t.decimal :column9
      t.datetime :column10
      t.timestamp :column11
      t.time :column12
      t.date :column13
      t.binary :column14
      t.boolean :column15
      
      t.timestamps
      
      t.references :model1
      t.belongs_to :model2, :polymorphic => true
    end
  end
end

class MyModelsRemoveColumn < ActiveRecord::Migration
  def self.up
    change_table(:my_models) do |t|
      t.remove :column1
      t.remove_index :column2
      t.remove_timestamps
      t.remove_references :model1
      t.remove_belongs_to :model2, :polymorphic => true
    end
  end
end

class MyModelsChangeColumn < ActiveRecord::Migration
  def self.up
    change_table(:my_models) do |t|
      t.change :column3, :string, :limit => 20
      t.change_default :column3, 'default'
      t.rename :column4, :column40
    end
  end
end
