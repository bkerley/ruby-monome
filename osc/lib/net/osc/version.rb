module Net
  module OSC
    module VERSION
      MAJOR    = 0
      MINOR    = 1
      TINY     = nil
      REVISION = "$Revision: 198 $"[/\d+/].to_i
    end
  
    Version = [VERSION::MAJOR, VERSION::MINOR, VERSION::TINY || VERSION::REVISION].join(".")
  end
end
