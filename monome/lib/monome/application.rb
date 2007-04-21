module Monome
  class Application < Net::OSC::Application
    attr_reader :grid

    def self.default_options
      super.merge(:port => 8000)
    end
  
    on :initialize do
      @grid = Grid.new(device)
      device.clear
    end
    
    on :end do
      device.clear
    end

    protected
      def toggle(row, column)
        return unless value = grid[row, column]
        grid[row, column] = value == 0 ? 1 : 0
      end
  end
end
