module Monome
  class Grid
    attr_reader :device
    attr_reader :rows
  
    def initialize(device)
      @device = device
      add_rows!
      add_leds!
      rows.freeze
    end
  
    def [](row, column)
      rows[row][column]
    end
    
    def []=(row, column, led)
      rows[row][column] = led
    end
  
    def turn_row(row, direction)
      returning self do
        rows[row].turn direction
      end
    end
  
    def turn_column(column, direction)
      returning self do
        columns[column].each do |led|
          led.turn direction
        end
      end
    end
  
    def clear
      returning self do
        add_leds!
        device.clear
      end
    end
    
    def each_row(&block)
      rows.each &block
    end
  
    def invert
      returning self do
        each_row do |row|
          row.invert
        end
      end
    end
  
    def inspect
      returning value = super[/(?:.*?) /] do
        value << "[\n"
        rows.each {|row| value << "  #{row.inspect.gsub(/1/, "\x1B[1m1\x1B[0m")}\n" }
        value << "]>"
      end
    end
    
    def columns
      rows.transpose
    end
  
    def leds
      rows.flatten
    end
    alias_method :to_a, :leds

    protected      
      def add_rows!
        @rows = Array.new(device.class.columns)
        
        device.class.rows.times do |row_number|
          rows[row_number] = Row.new(row_number)
        end
      end
      
      def add_leds!
        rows.each do |row|
          device.class.columns.times do |column_number|
            LED.new(row.number, column_number).add_to(self)
          end
        end
      end
  end
end
