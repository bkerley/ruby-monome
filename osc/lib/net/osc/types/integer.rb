class Integer
  include Net::OSC::Type
  
  osc_type :integer, "i" do |value|
    Integer(value)
  end
  
  def self.read_osc_argument(arguments)
    [arguments.unpack("N").first, 4]
  end
  
  def to_osc_string
    [self].pack("N")
  end
end

