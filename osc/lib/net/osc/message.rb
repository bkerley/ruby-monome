module Net
  module OSC
    class Message < Packet
      attr_reader :address, :argument_list, :arguments
  
      def self.from_osc_packet(packet)
        packet  = packet.dup
        address = String.extract_osc_argument!(packet)
        types   = String.extract_osc_argument!(packet)[1..-1]

        arguments = types.split(//).map do |identifier|
          klass = OSC::Type.class_for_identifier(identifier)
          klass.extract_osc_argument!(packet)
        end
    
        new address, arguments
      end
  
      def initialize(address, arguments)
        @address       = address
        @argument_list = Arguments.from_arguments(arguments)
        @arguments     = arguments
      end
  
      protected
        def packet_contents
          [address, argument_list, *arguments]
        end
    end
  end
end
