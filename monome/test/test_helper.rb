require File.dirname(__FILE__) + '/../lib/monome'
require 'test/unit'
require 'rubygems'
require 'mocha'
require 'stubba'

class Test::Unit::TestCase
  def mock_led_device!
    Monome::LED.any_instance.stubs(:device).returns(mock_device)
  end
  
  def mock_device
    returning device = mock('device') do 
      device.stubs(:led)
      device.stubs(:clear)
      device.class.stubs(:rows).returns(7)
      device.class.stubs(:columns).returns(7)
    end
  end
    
end