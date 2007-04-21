require File.join(File.dirname(__FILE__), "..", "lib", "monome")

$stdout.sync = true

class Marquee < Monome::Application
  every 0.1, :marquee

  on :initialize do
    @marquee = Monome::Marquee.new(grid, :row => 1)
    
    Thread.new do 
      $stdout.print("> ")
      $stdin.each_line do |line|
        $stdout.print("> ")
        @marquee.write(line)
      end
      exit
    end
  end
  
  on :marquee do
    @marquee.display
  end
  
  on :press do |column, row, state|
    marquee_timer.toggle if state == 1
  end
end

if __FILE__ == $0
  Marquee.run(:device => Monome::M40h.new)
end