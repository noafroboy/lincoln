require 'active_record'

ActiveRecord::Base.establish_connection({
  :adapter => 'mysql',
  :host => 'localhost',
  :user => 'root',
  :database => 'lincoln_test'
})

def create_my_models
  ActiveRecord::Schema.define do
    create_table "my_models", :force => true do |t|
      t.string :column1, :column2, :column3
    end
  end
end
