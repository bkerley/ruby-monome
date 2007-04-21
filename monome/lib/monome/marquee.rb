module Monome
  class Marquee
    attr_reader :grid, :options
    
    def self.default_options
      { :text => {}, :row => 0 }
    end
    
    def initialize(grid, options = {})
      @options = self.class.default_options.merge(options)
      @grid = grid
      reset
    end
    
    def reset
      @text = []
      @offset = grid.columns - 1
    end

    def write(text)
      @text << Monome::Text.new(text)
    end
    
    def display
      return unless current_text = @text.first

      if current_text.draw_to(grid, :row => options[:row], :column => @offset)
        @offset -= 1
      else
        @text.shift
        @offset = grid.columns - 1
      end
    end
  end
end