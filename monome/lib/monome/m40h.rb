module Monome
  class M40h < Device
    class << self
      def rows;    8 end
      def columns; 8 end
    end

    osc_method(:led) do |arg|
      arg.integer :row
      arg.integer :column
      arg.integer :state
    end

    osc_method(:led_row) do |arg|
      arg.integer :row
      arg.integer :state
    end

    osc_method(:led_col) do |arg|
      arg.integer :col
      arg.integer :state
    end

    osc_method(:intensity) do |arg|
      arg.float :intensity
    end

    osc_method(:test) do |arg|
      arg.integer :state
    end

    osc_method(:shutdown) do |arg|
      arg.integer :state
    end

    def each_row(&block)
      returning self do
        self.class.rows.times(&block)
      end
    end
  
    def clear
      in_bundle do
        each_row do |row|
          led_row(row, 0)
        end
      end
    end
  end
end
