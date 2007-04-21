module Monome
  class Grid
    attr_reader :device
  
    def initialize(device)
      @device = device
      initialize_leds
    end
  
    def [](row, column)
      leds[row][column]
    end
  
    def []=(row, column, state)
      led(column, row, state)
    end
  
    def led(row, column, state)
      returning self do
        raise ArgumentError, "must be 0 or 1" unless state == 0 || state == 1
        leds[column][row] = state
        device.led(row, column, state)
      end
    end
  
    def led_row(row, state)
      returning self do
        leds[row] = state_to_row(state)
        device.led_row(row, state)
      end
    end
  
    def led_col(column, state)
      returning self do
        state_to_row(state).each_with_index do |value, row|
          leds[row][column] = value
        end
        device.led_col(column, state)
      end
    end

    def row(row)
      leds[row].dup if leds[row]
    end
  
    def each_row(&block)
      returning self do
        device.each_row do |row_number|
          yield row(row_number), row_number
        end
      end
    end
  
    def clear
      returning self do
        initialize_leds
        device.clear
      end
    end
  
    def invert
      device.in_bundle do
        each_row do |row, row_number|
          led_row(row_number, ~row_to_state(row))
        end
      end
    end
  
    def inspect
      returning value = super[/(?:.*?) /] do
        value << "[\n"
        leds.each { |row| value << "  #{row.inspect.gsub(/1/, "\x1B[1m1\x1B[0m")}\n" }
        value << "]>"
      end
    end
    
    def rows
      device.rows
    end
    
    def columns
      device.columns
    end
  
    def state_to_row(state)
      [state].pack("c").unpack("b8")[0].split(//).map { |i| i.to_i }
    end
  
    def row_to_state(row)
      [row.join].pack("b8")[0]
    end
  
    def to_a
      leds.flatten
    end

    protected
      attr_reader :leds
  
      def initialize_leds
        @leds = Array.new(device.class.rows) { [0] * device.class.columns }
      end
  end
end
