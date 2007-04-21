require File.join(File.dirname(__FILE__), "canvas")

class Flow < Canvas
  every 1, :shift
  
  on :press do |column, row, state|
    if state == 1
      shift_timer.toggle if row == 0 && column == 7
    end
  end
  
  on :shift do
    device.in_bundle do
      7.downto(1) do |row|
        grid.led_row(row, grid.row_to_state(grid.row(row - 1)))
      end
      grid.led_row(0, 0)
    end
  end
end

if __FILE__ == $0
  Flow.run(:device => Monome::M40h.new)
end
