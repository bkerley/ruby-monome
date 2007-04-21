module Monome
  class LED
    attr_reader :row, :column
    
    def initialize(row, column)
      @row, @column = row, column
      @on = false
    end
    
    def on?
      @on
    end
    
    def off?
      !on?
    end
    
    def turn(direction)
      @on = case direction
              when :on,  1 then true
              when :off, 0 then false
              else         raise ArgumentError, "You can only turn an LED :on or :off"
            end
      device.led(column, row, to_i)
      self
    end
    
    def invert
      turn on? ? :off : :on
    end
    
    def to_i
      on? ? 1 : 0
    end
    
    def add_to(grid)
      grid[row, column] = self
      self.grid = grid
    end
    
    def device
      grid.device
    end
    
    def inspect
      to_i
    end
    
    def coordinates
      [row, column]
    end
    
    def top_right?
      coordinates == [0, grid.device.class.columns - 1]
    end
    
    private
      attr_accessor :grid
  end
end