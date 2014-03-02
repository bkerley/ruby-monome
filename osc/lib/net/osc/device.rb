require "socket"

module Net
  module OSC
    class Device
      attr_reader :options
  
      class << self
        def default_options
          {}
        end
    
        def osc_method_arguments
          @osc_method_arguments ||= {}
        end
    
        def osc_method(name, endpoint=nil, &block)
          name = name.to_sym
          args = osc_method_arguments[name] = Arguments.new(&block)
      
          endpoint ||= name.to_s.gsub('_', '/')

          class_eval <<-EOS, __FILE__, __LINE__
            def #{name}(*args)
              args = self.class.osc_method_arguments[#{name.inspect}].bind(args)
              send_osc_message(#{endpoint.inspect}, *args)
            end
          EOS
        end
      end
  
      def initialize(options = {})
        @options = self.class.default_options.merge(options)
        @bundle, @bundle_depth = nil, 0
        establish_connection!
      end
  
      def in_bundle
        @bundle ||= Bundle.new
        @bundle_depth += 1
        returning value = yield(@bundle) do
          if (@bundle_depth -= 1).zero?
            bundle, @bundle = @bundle, nil
            send_osc_packet(bundle)
          end
        end
      end
  
      protected
        def establish_connection!
          @socket = UDPSocket.new
          @socket.connect(options[:hostname], options[:send_port])
        end
      
        def send_osc_packet(packet)
          if @bundle
            @bundle.packets << packet
          else
            @socket.send(packet.to_osc_string, 0)
          end
        end
      
        def send_osc_message(name, *args)
          message = Message.new(method_address(name), args)
          send_osc_packet(message)
        end
      
        def method_address(name)
          File.join("/", (options[:address_prefix] || "").to_s, name.to_s)
        end
    end
  end
end
