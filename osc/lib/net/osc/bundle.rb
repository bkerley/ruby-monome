module Net
  module OSC
    class Bundle < Packet
      attr_reader :packets
    
      def initialize(packets = [])
        @packets = packets
      end
    
      protected
        def packet_contents
          returning contents = ["#bundle"] do
            contents << TimeTag.immediately
            packets.each do |packet|
              contents << packet.size
              contents << packet
            end
          end
        end
    end
  end
end
