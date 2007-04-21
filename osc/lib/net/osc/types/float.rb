class Float
  include Net::OSC::Type
  
  osc_type :float, "f" do |value|
    Float(value)
  end
  
  def self.read_osc_argument(arguments)
    [arguments.unpack("g").first, 8]
  end
  
  def to_osc_string
    [self].pack("g")
  end
end

