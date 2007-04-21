module Net
  module OSC
    class TimeTag
      attr_reader :seconds, :fraction
    
      SECONDS_FROM_1900_TO_1970 = 2208988800
    
      class << self
        def immediately
          new(0, 1)
        end
      
        def from_time(time)
          seconds, remainder = (time.to_f + SECONDS_FROM_1900_TO_1970).divmod(1)
          fraction = remainder * (2 ** 32)
          new(seconds.to_i, fraction.to_i)
        end
      end
    
      def initialize(seconds, fraction)
        @seconds, @fraction = seconds, fraction
      end
    
      def immediately?
        seconds == 0 && fraction == 1
      end
    
      def to_osc_string
        [seconds, fraction].pack("N2")
      end
    
      def to_time
        return Time.now if immediately?
        time = Time.at(seconds - SECONDS_FROM_1900_TO_1970)
        time + fraction / (2 ** 32.0)
      end
    end
  end
end
