module Net
  module OSC
    class ArgumentInfo < Struct.new(:name, :type, :transformation, :options)
      def bind(value)
        transformation ? transformation.call(value) : osc_type_class.osc_value(value)
      end
  
      def osc_type_class
        OSC::Type.classes[type]
      end
  
      def osc_type_identifier
        osc_type_class.osc_type_identifier
      end
    end
  end
end
