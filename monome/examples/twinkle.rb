require File.join(File.dirname(__FILE__), "..", "lib", "monome")

class Twinkle < Monome::Application
  every 0.01, :twinkle
  
  on :twinkle do
    rand(8).times do
      row, column = rand(8), rand(8)
      toggle(row, column)
    end
  end
  
  on :press do
    exit
  end
end

if __FILE__ == $0
  Twinkle.run(:device => Monome::M40h.new)
end
