require File.join(File.dirname(__FILE__), "..", "lib", "monome")

class Clock < Monome::Application
  every 1,      :clock
  every 0.1,    :marquee
  every 0.0625, :binary_clock
  
  on :initialize do
    @marquee = Monome::Marquee.new(grid, :row => 1)
    marquee_timer.stop
    binary_clock_timer.stop
    display_clock
  end

  on :clock do
    if (c = cursor) == @last_cursor
      toggle(*c)
    else
      fill_to(*c)
    end
    @last_cursor = c
  end
  
  on :marquee do
    @marquee.display
  end
  
  on :binary_clock do
    display_binary_clock
  end
  
  on :press do |row, column, state|
    if row == 7 && column == 7
      if state == 1
        if binary_clock_timer.stopped?
          clock_timer.stop
          marquee_timer.stop
          binary_clock_timer.start
        else
          binary_clock_timer.stop
          clock_timer.start
          display_clock
        end
      end
      stop
    end
  end
  
  on :press do |row, column, state|
    clock_timer.toggle
    if marquee_timer.toggle
      display_clock
    else
      display_time
    end
  end
  
  protected
    def cursor
      time = Time.now
      leds = device.rows * device.columns
      pos  = ((time.hour * 60 + time.min) / 1440.0 * leds).floor
      row, column = pos / device.columns, pos % device.columns
    end
    
    def time
      Time.now.strftime("%I:%M %p").sub(/^0/, "")
    end

    def display_clock
      device.intensity(0.5)
      fill_to(*cursor)
      toggle(*cursor)
    end
    
    def display_time
      grid.clear
      device.intensity(1)
      @marquee.reset
      @marquee.write(time)
    end
    
    def display_binary_clock
      device.intensity(0.5)
      binary_time_data = binary_time
      grid.each_row do |row_data, row|
        offset = row * 8
        grid.led_row(row, grid.row_to_state(binary_time_data[offset, 8]))
      end
    end
    
    def fill_to(row, column)
      device.in_bundle do
        grid.each_row do |row_data, r|
          case
          when r < row
            grid.led_row(r, grid.row_to_state([1] * device.columns))
          when r == row
            on, off = column, device.columns - column
            grid.led_row(r, grid.row_to_state([1] * on + [0] * off))
          when r > row
            grid.led_row(r, 0)
          end
        end
      end
    end
    
    def binary_time
      time = Time.now
      ipart = time.to_i
      fpart = time.usec / 2**18
      [gray(ipart), gray(fpart)].pack("N*").unpack("B*").first.split(//).map { |i| i.to_i }
    end
    
    def gray(number)
      number ^ (number >> 1)
    end
end

if __FILE__ == $0
  Clock.run(:device => Monome::M40h.new)
end
