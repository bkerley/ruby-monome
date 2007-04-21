require File.join(File.dirname(__FILE__), "..", "lib", "monome")

class Timer < Monome::Application
  TICKS_PER_MINUTE = 240
  
  every 60 / TICKS_PER_MINUTE.to_f, :tick
  
  on :initialize do
    reset
  end
  
  on :tick do
    case @state
    when :progress
      @state = :alert if (@value -= 1).zero?
      render_progress

    when :alert
      invert_display
    end
  end
  
  on :press do |column, row, state|
    case @state
    when :blank, :progress
      if state == 1
        @state = :peek
        @new_value = position_to_value(row, column)
        render_value(@new_value)
      end

    when :peek
      if state == 1
        @state = :remain
        render_value
      else
        @state = :progress
        @value = @new_value
        render_progress
      end
      
    when :remain
      if state == 1
        reset
      else
        @state = :progress
        render_progress
      end

    when :alert
      reset if state == 1
    end
  end
  
  protected
    def reset
      @state = :blank
      @value = 0
      grid.clear
    end
  
    def render_progress
      grid.clear and return if @value.zero?
      value  = value_in_minutes
      value -= 1 if @value % 2 == 0
      fill_to(value)
    end
    
    def render_value(value = @value)
      grid.clear
      text = Monome::Text.new(value_in_minutes(value).to_s)
      text.draw_to(grid, :row => 1, :column => 0)
    end
    
    def invert_display
      grid.invert
    end
    
    def position_to_value(row, column)
      position_to_minute(row, column) * TICKS_PER_MINUTE - 1
    end
    
    def position_to_minute(row, column)
      row * 8 + column + 1
    end
    
    def value_in_minutes(value = @value)
      value / TICKS_PER_MINUTE + 1
    end

    def fill_to(value)
      sprite = Monome::Sprite.blank(8, 8)
      sprite[0, value] = [1] * value if value > 0
      sprite.draw_to(grid)
    end
end

if __FILE__ == $0
  Timer.run(:device => Monome::M40h.new)
end
