module Monome
  class Text
    attr_reader :options, :text
    
    def self.default_options
      { :font => Monome::Fonts::Standard, :spacing => 1 }
    end
    
    def initialize(text, options = {})
      @options = self.class.default_options.merge(options)
      @text = text.chomp.strip
    end
    
    def draw_to(grid, draw_options = {})
      grid.device.in_bundle do
        row, column = draw_options[:row] || 0, draw_options[:column] || 0
        offset = column < 0 ? -column % cell_width : -column
        space  = Sprite.blank(options[:spacing], font.height)
      
        chars_at(grid, column).each_with_index do |char, index|
          offset_column = (index * cell_width) - offset
          char.draw_to(grid,  :row => row, :column => offset_column)
          space.draw_to(grid, :row => row, :column => offset_column + font.width)
        end.any?
      end
    end
      
    protected
      def font
        options[:font]
      end
      
      def chars
        @chars ||= text.split(//).map do |char|
          font[char[0]]
        end
      end
      
      def cell_width
        font.width + options[:spacing]
      end
      
      def chars_at(grid, column)
        offset = column < 0 ? -column : 0
        first  = offset / cell_width
        length = (((offset % cell_width) + grid.columns) / cell_width.to_f).ceil
        
        chars[first, length]
      end
  end
end
