require File.join(File.dirname(__FILE__), "..", "lib", "monome")

class Canvas < Monome::Application
  on :press do |column, row, state|
    grid.invert and stop if row == 7 && column == 7
  end
  
  on :press do |column, row, state|
    toggle(row, column) if state == 1
  end
end

if __FILE__ == $0
  Canvas.run(:device => Monome::M40h.new)
end
