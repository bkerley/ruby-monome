require File.join(File.dirname(__FILE__), "..", "lib", "monome")

class Test < Monome::Application
  every 1, :invert_all
  
  on :press do |column, row, state|
    grid[row, column] = state.zero? ? 1 : 0
  end
  
  on :invert_all do
    grid.invert
  end
end

Test.run(:device => Monome::M40h.new) if $0 == __FILE__
