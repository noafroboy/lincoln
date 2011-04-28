module Lincoln
  module Matchers
    def have_index(column_name, &blk)
      ColumnIndex.new(column_name, &blk)
    end
    
    class ColumnIndex
      def initialize(columns_for_index)
        @columns_for_index = columns_for_index
        @columns_for_index = [columns_for_index] unless columns_for_index.kind_of?(Array)
        @columns_for_index = @columns_for_index.map { |c| c.to_s }
      end
      
      def matches?(klass)
        @klass = klass.class
        @index = find_index
        
        index_exists?
      end
      
      def description
        "have an index for column '#{@columns_for_index.inspect}'"
      end

      def failure_message
        "Expected index with name '#{@columns_for_index.inspect}'"
      end
      
      def negative_failure_message
        "Did not expect column with name '#{@columns_for_index.inspect}'"
      end
      
      private
      
      def find_index
        indexes = @klass.connection.indexes(@klass.table_name).find_all do |index|
          index.columns == @columns_for_index
        end
        indexes.size == 1 ? indexes.first : nil
      end
      
      def index_exists?
        !@index.nil?
      end
      
    end
  end
end
