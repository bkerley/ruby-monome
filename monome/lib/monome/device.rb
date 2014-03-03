module Monome
  class Device < Net::OSC::Device
    class << self
      def default_options
        { :hostname => "localhost", :send_port => 8080, :address_prefix => "monome/grid" }
      end
    end

    def rows
      self.class.rows
    end
    
    def columns
      self.class.columns
    end
  end
end
