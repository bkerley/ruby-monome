module Net
  module OSC
    class ArgumentError < Error; end

    class Arguments
      def self.from_arguments(arguments)
        new do |args|
          name = "a"
          arguments.each do |argument|
            args.send(argument.class.osc_internal_name, name)
            name.succ!
          end
        end
      end
  
      def initialize
        @arguments = []
        @arguments_by_name = {}
        yield self
      end
  
      def bind(args)
        raise ArgumentError, "wrong number of arguments (#{args.length} for #{arguments.length})" if
          args.length != arguments.length
      
        args.inject([]) do |results, arg|
          begin
            info = arguments[results.length]
            results << info.bind(arg)
          rescue => e
            raise ArgumentError, "can't convert #{info.name}:#{arg.inspect} to #{info.type}"
          end
        end
      end
  
      def integer(name, options = {})
        define_argument(name, :integer, options)
      end

      def float(name, options = {})
        define_argument(name, :float, options)
      end

      def string(name, options = {})
        define_argument(name, :string, options)
      end

      def to_osc_string
        ",#{arguments.map { |arg| arg.osc_type_identifier }.join}".to_osc_string
      end

      protected
        attr_reader :arguments, :arguments_by_name
  
        def define_argument(name, type, options = {}, &transformation)
          name, type  = name.to_sym, type.to_sym
          raise ArgumentError, "#{name} already defined" if arguments_by_name[name]

          argument_info = ArgumentInfo.new(name, type, transformation, options)
          arguments << arguments_by_name[name] = argument_info
        end
    end
  end
end
