module Net
  module OSC
    class Packet
      def to_osc_string
        @osc_string ||= packet_contents.map { |value| value.to_osc_string }.join
      end
    
      def size
        to_osc_string.size
      end
    end
  end
end
