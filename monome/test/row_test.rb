require File.dirname(__FILE__) + '/test_helper'

class RowTest < Test::Unit::TestCase
  def setup
    @row = Monome::Row.new(0)
    mock_led_device!
    8.times do |column_number|
      @row << Monome::LED.new(0, column_number)
    end
  end
  
  def test_a_row_has_a_number
    assert @row.number
    assert_equal 0, @row.number
  end
  
  def test_turning_a_row_on_and_off
    assert @row.all? {|led| led.off?}
    assert_nothing_raised do
      @row.turn :on
    end
    assert @row.all? {|led| led.on?}
  end
  
  def test_inverting_a_row
    assert @row.all? {|led| led.off? }
    assert_nothing_raised do
      @row.invert
    end
    assert @row.all? {|led| led.on? }
  end
end