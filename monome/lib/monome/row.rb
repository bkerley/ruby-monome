module Monome
  class Row < Array
    attr_reader :number
    def initialize(number)
      super()
      @number = number
    end

    def turn(direction)
      each do |led|
        led.turn(direction)
      end
    end
    
    def invert
      each do |led|
        led.invert
      end
    end
  end
end