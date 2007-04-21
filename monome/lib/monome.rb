$:.unshift File.dirname(__FILE__)

if File.directory? osc_path = File.join(File.dirname(__FILE__), "..", "..", "osc", "lib")
  $:.unshift osc_path
elsif File.directory? osc_path = File.join(File.dirname(__FILE__), "..", "vendor", "osc", "lib")
  $:.unshift osc_path
end

require "net/osc"

require "monome/version"

require "monome/device"
require "monome/m40h"

require "monome/grid"
require "monome/sprite"

require "monome/font"
require "monome/fonts/standard"
require "monome/text"
require "monome/marquee"

require "monome/application"
