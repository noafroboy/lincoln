# ActiveRecord::ConnectionAdapters::SchemaStatements
# module ActiveRecord
#   module ConnectionAdapters
#     module SchemaStatements
#       def change_table(table_name)
#         yield Lincoln::Table.new(table_name, self)
#       end
#     end
#   end
# end

module Lincoln
  module ChangeTableOptimization
    def change_table(table_name)
      @table_name = table_name
      @new_table_name = generate_table_name(table_name)
      copy_table_structure(table_name, @new_table_name)
      
      super(@new_table_name)
      
      copy_data(table_name, @new_table_name)
      swap_tables(@new_table_name, table_name)
      
      @table_name = nil
      @new_table_name = nil
    end
    
    def add_column(table_name, column_name, type, options = {})
      track("add", column_name)
      super
    end
    
    def remove_column(table_name, *column_names)
      column_names.each { |c| track("remove", c) }
      super
    end
    
    def rename_column_with_tracking(table_name, column_name, new_column_name)
      track("rename", [column_name, new_column_name])
      rename_column_without_tracking(table_name, column_name, new_column_name)
    end
    
    def index_name(table_name, options)
      if @table_name != nil
        return super(@table_name, options)
      end
      super(table_name, options)
    end
    
    private
    
    def track(operation, data)
      @track ||= {}
      @track[operation] ||= []
      @track[operation].push(data)
    end
    
    def column_removed?(column_name)
      @track ||= {}
      @track["remove"] ||= []
      @track["remove"].include?(column_name)
    end
    
    def column_added?(column_name)
      @track ||= {}
      @track["add"] ||= []
      @track["add"].include?(column_name)
    end
    
    def new_column_name(column_name)
      @track ||= {}
      @track["rename"] ||= []
      @track["rename"].each do |rename_array|
        if rename_array.first.to_s == column_name.to_s
          return rename_array.last
        end
      end
      column_name
    end
    
    def generate_table_name(table_name)
      "#{table_name}_#{Time.now.to_i}_#{(rand * 100_000_000).to_i}"
    end
    
    def copy_table_structure(table_name, new_table_name)
      execute("CREATE TABLE #{quote_table_name(new_table_name)} LIKE #{quote_table_name(table_name)}")
    end
    
    def copy_data(table_name, new_table_name)
      original_column_names = columns(table_name).map do |column|
        return nil if column_removed?(column.name) || column_added?(column.name)
        quote_column_name(column.name)
      end.flatten
      
      new_column_names = columns(table_name).map do |column|
        return nil if column_removed?(column.name) || column_added?(column.name)
        quote_column_name(new_column_name(column.name))
      end.flatten
      
      execute("INSERT INTO #{quote_table_name(new_table_name)} (#{new_column_names.join(", ")}) SELECT #{original_column_names.join(", ")} FROM #{quote_table_name(table_name)}")
    end
    
    def swap_tables(new_table_name, table_name)
      rename_table(table_name, "#{new_table_name}_bak")
      rename_table(new_table_name, table_name)
    end
  end
end

ActiveRecord::ConnectionAdapters::MysqlAdapter.send(:include, Lincoln::ChangeTableOptimization)
ActiveRecord::ConnectionAdapters::MysqlAdapter.send(:alias_method_chain, :rename_column, :tracking)
