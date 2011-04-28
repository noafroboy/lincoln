module Lincoln
  module Matchers
    def have_column(column_name, &blk)
      ColumnMatcher.new(column_name, &blk)
    end
    
    class ColumnMatcher
      def initialize(column_name)
        @column_name = column_name.to_s
      end
      
      def matches?(klass)
        @klass = klass.class
        @column = find_column
        
        column_exists? && 
          correct_type? && 
          correct_precision? &&
          correct_default? &&
          correct_limit?
      end
      
      def with_type(type)
        @type = type.to_s
        self
      end
      
      def with_precision(precision)
        @precision = precision.to_s
        self
      end
      
      def with_default(default)
        @default = default.to_s
        self
      end
      
      def with_limit(limit)
        @limit = limit.to_s
        self
      end

      def description
        "have a column named #{@column_name}"
      end

      def failure_message
        "Expected column with name '#{@column_name}'"
      end
      
      def negative_failure_message
        "Did not expect column with name '#{@column_name}'"
      end
      
      private
      
      def find_column
        columns = @klass.columns.find_all { |c| c.name == @column_name }
        columns.size == 1 ? columns.first : nil
      end
      
      def column_exists?
        !@column.nil?
      end
      
      def correct_type?
        return true if @type.nil?
        
        if @column.type.to_s != @type
          @missing = "actual column type was '#{@column.type}'"
          false
        else
          true
        end
      end
      
      def correct_precision?
        return true if @precision.nil?
        
        if @column.precision.to_s != @precision
          @missing = "actual column precision was '#{@column.precision}'"
          false
        else
          true
        end
      end
      
      def correct_default?
        return true if @default.nil?
        
        if @column.default.to_s != @default
          @missing = "actual column default was '#{@column.default}'"
          false
        else
          true
        end
      end
      
      def correct_limit?
        return true if @limit.nil?
        
        if @column.limit.to_s != @limit
          @missing = "actual column limit was '#{@column.limit}'"
          false
        else
          true
        end
      end
    end
  end
end
