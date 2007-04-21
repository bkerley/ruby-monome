module Net
  module OSC
    module Type
      class << self
        def included(base)
          base.extend(ClassMethods)
        end
  
        def classes
          @classes ||= {}
        end
  
        def identifiers
          @identifiers ||= {}
        end
    
        def constructors
          @constructors ||= {}
        end
    
        def class_for_identifier(identifier)
          classes[identifiers.find { |name, i| identifier == i }.first]
        end
      end
  
      module ClassMethods
        def osc_type(internal_name, osc_type_identifier, &block)
          internal_name       = internal_name.to_sym
          osc_type_identifier = osc_type_identifier.dup.freeze
      
          OSC::Type.classes[internal_name]      = klass = self
          OSC::Type.identifiers[internal_name]  = osc_type_identifier
          OSC::Type.constructors[internal_name] = block || Proc.new { |value| klass.new(value) }
      
          class_eval do
            (class << self; self end).send(:define_method, :osc_internal_name) { internal_name }
          end
        end

        def osc_type_identifier
          OSC::Type.identifiers[osc_internal_name]
        end

        def osc_value(value)
          OSC::Type.constructors[osc_internal_name].call(value)
        end
    
        def extract_osc_argument!(arguments)
          value, length = read_osc_argument(arguments)
          arguments.slice! 0, length
          value
        end
      end
    end
  end
end
