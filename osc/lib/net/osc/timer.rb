module Net
  module OSC
    class Timer
      attr_reader :interval, :block
  
      def initialize(interval, &block)
        @interval = interval
        @block  = block
        @thread = Thread.new { run }
        start
      end
  
      def stopped?
        @stopped
      end
  
      def stop
        @stopped = true
      end
  
      def start
        @stopped = false
      end
    
      def toggle
        stopped? ? start : stop
      end
  
      protected
        def run
          loop do
            sleep interval
            block.call unless stopped?
          end
        end
    end
  end
end
