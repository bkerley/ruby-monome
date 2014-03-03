class String
  include Net::OSC::Type
  
  osc_type :string, "s" do |value|
    String(value)
  end
  
  def self.read_osc_argument(arguments)
    string = arguments[index = 0, 4]
    string << arguments[index += 4, 4] while string[-1] != "\0"
    [string.gsub!(/\0+$/, ""), index + 4]
  end
  
  def to_osc_string
    payload = self[/^(.*)(?:\0|$)/, 1]
    payload << "\0" * (4 - payload.length % 4)
  end
end
