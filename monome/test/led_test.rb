require File.dirname(__FILE__) + '/test_helper'

class LEDTest < Test::Unit::TestCase
  def setup
    mock_led_device!
    @led = Monome::LED.new(0, 0)
  end
  
  def test_an_led_is_off_initially
    assert @led.off?
    assert !@led.on?
  end
  
  def test_an_led_has_a_row_and_a_column
    assert_equal 0, @led.row
    assert_equal 0, @led.column
  end
  
  def test_an_led_can_be_turned_on_and_off    
    assert_nothing_raised do
      @led.turn :on
    end
    
    assert @led.on?
    
    assert_nothing_raised do
      @led.turn :off
    end
    
    assert @led.off?
  end
  
  def test_you_can_only_turn_an_led_on_or_off
    assert_raises(ArgumentError) do
      @led.turn :the_other_cheek
    end
  end
  
  def test_inverting_an_led
    assert @led.off?
    assert_nothing_raised do
      @led.invert
    end
    assert @led.on?
  end
  
  def test_inspecting_an_led_just_looks_like_a_binary_fixnum
    assert_equal 0, @led.inspect
    @led.turn :on
    assert_equal 1, @led.inspect
  end
  
  def test_row_as_a_digit
    assert_equal 0, @led.to_i
  end
  
  def test_coordinates_for_an_led
    assert_equal [0, 0], @led.coordinates
  end
  
  def test_adding_an_led_to_a_grid
    grid = Monome::Grid.new(mock_device)
    @led.add_to grid
    assert_equal @led.object_id, grid[@led.row, @led.column].object_id
  end
  
  def test_top_right_predicate
    grid = Monome::Grid.new(mock_device)
    assert !grid.leds.first.top_right?
    assert grid.rows.first.last.top_right?
  end
end