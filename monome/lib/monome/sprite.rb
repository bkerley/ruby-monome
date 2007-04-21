module Monome
  class Sprite < Array
    attr_accessor :width
    
    def self.blank(width, height)
      new width, *[0] * width * height
    end
    
    def initialize(width, *values)
      @width = width
      super values
    end
    
    def height
      length / width + (length % width == 0 ? 0 : 1)
    end
    
    def row(r)
      return [] if r > height
      self[width * r, width]
    end
    
    def draw_to(grid, options = {})
      r, c, x = options[:row] || 0, options[:column] || 0, 0
      width, height = self.width, self.height
      
      if c < 0
        x = c.abs
        return if x >= width 
        width -= x
      end

      grid.device.in_bundle do
        grid.each_row do |values, row_number|
          if row_number >= r && row_number < r + height 
            values[c + x, width] = row(row_number - r)[x, width]
            grid.led_row(row_number, grid.row_to_state(values))
          end
        end
      end
    end
    
    def encode
      [join].pack("b*")
    end
  end
end
