module Net
  module OSC
    class Handler
      attr_reader :address, :port
    
      def initialize(address, port)
        @address = address
        @port    = port
        @socket  = UDPSocket.new
      end
    
      def run
        socket.bind(address, port)
        each_message do |message|
          yield message
        end
      ensure
        socket.close
      end
    
      protected
        attr_reader :socket
    
        def each_message
          loop do
            yield Message.from_osc_packet(socket.recvfrom(4096).first)
          end
        end
    end
  end
end
