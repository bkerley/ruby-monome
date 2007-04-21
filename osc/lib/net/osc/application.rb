module Net
  module OSC
    class Application
      attr_reader :options, :device
  
      class << self
        def default_options
          { :address => "" }
        end
    
        def on(event_name, &block)
          event_name = event_name.to_sym
          events[event_name] ||= []
          events[event_name] << block
        end
      
        def every(number_of_seconds, event_name)
          timer_name = "#{event_name}_timer".to_sym
          event_name = event_name.to_sym

          attr_reader timer_name

          on :initialize do
            timer = Timer.new(number_of_seconds) { dispatch_event(event_name) }
            instance_variable_set("@#{timer_name}", timer)
          end
        end
    
        def events
          @events ||= ancestors.reverse[0..-2].inject({}) do |events, ancestor|
            ancestor_events = ancestor.respond_to?(:events) ? ancestor.events : {}
            events.merge(ancestor_events)
          end
        end
    
        def run(options = {})
          new(options).run
        end
      end
  
      def initialize(options = {})
        @options = options = self.class.default_options.merge(options)
        @device  = options[:device]
        @handler = OSC::Handler.new(options[:address], options[:port])
        dispatch_event(:initialize)
      end
  
      def run
        handler.run do |message|
          event_name = extract_event_name_from_address(message.address)
          dispatch_event(event_name, message.arguments)
        end
      ensure
        dispatch_event(:end)
      end
  
      protected
        attr_reader :handler, :events
  
        def extract_event_name_from_address(address)
          prefix = Regexp.escape(device.options[:address_prefix])
          event_name = address[/^\/#{prefix}\/(.*)/, 1]
          event_name ? event_name.to_sym : nil
        end
    
        def dispatch_event(event_name, arguments = [])
          if events[event_name]
            catch :stop do
              events[event_name].each do |event|
                event.bind(self).call(*arguments)
              end
            end
          end
        end
      
        def stop
          throw :stop
        end
    
        def events
          self.class.events
        end
    end
  end
end
