require File.join(File.dirname(__FILE__), "canvas")

class Sprite < Canvas
  on :initialize do
    sprite = Monome::Sprite.new 5,
      0, 1, 0, 1, 0,
      0, 1, 0, 1, 0,
      0, 0, 0, 0, 0,
      1, 0, 0, 0, 1,
      0, 1, 1, 1, 0
    
    sprite.draw_to(grid, :row => 1, :column => 1)
  end
end

if __FILE__ == $0
  Sprite.run(:device => Monome::M40h.new)
end
