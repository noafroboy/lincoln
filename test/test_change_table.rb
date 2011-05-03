require File.dirname(__FILE__) + "/test_helper"

class MyModelTest < ActiveSupport::TestCase
  setup do
    create_my_models
  end
  
  context "MyModel" do
    setup do
      MyModelsAddColumn.up
      MyModel.reset_column_information
    end

    should have_index("column2")
    should have_column("column4").with_type(:string)
    
    should have_column("created_at")
    should have_column("updated_at")
    
    should have_column("column5").with_type(:string)
    should have_column("column6").with_type(:text)
    should have_column("column7").with_type(:integer)
    should have_column("column8").with_type(:float)
    should have_column("column9").with_type(:integer).with_precision(10)
    should have_column("column10").with_type(:datetime)
    should have_column("column11").with_type(:datetime)
    should have_column("column12").with_type(:time)
    should have_column("column13").with_type(:date)
    should have_column("column14").with_type(:binary)
    should have_column("column15").with_type(:boolean)
    
    should have_column("model1_id").with_type(:integer)
    should have_column("model2_id").with_type(:integer)
    should have_column("model2_type").with_type(:string)
    
    context "remove columns" do
      setup do
        MyModelsRemoveColumn.up
        MyModel.reset_column_information
      end
      
      should_not have_column("column1")
      should_not have_index("column2")
      should_not have_column("created_at")
      should_not have_column("updated_at")
      should_not have_column("model1_id")
      should_not have_column("model2_id")
      should_not have_column("model2_type")
    end
    
    context "changes columns" do
      setup do
        MyModelsChangeColumn.up
        MyModel.reset_column_information
      end
      
      should_not have_column("column4")
      should have_column("column40")
      should have_column("column3").with_default('default')
      should have_column("column3").with_limit(20)
    end
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
