require File.dirname(__FILE__) + '/test_helper'

class GridTest < Test::Unit::TestCase
  def setup
    assert_nothing_raised do
      @grid = Monome::Grid.new(mock_device)
    end
  end
  
  def test_grid_is_made_up_of_leds
    @grid.each_row do |row|
      assert row.all? {|led| led.is_a?(Monome::LED)}
    end
  end
  
  def test_grid_has_rows
    @grid.each_row do |row|
      assert_kind_of Monome::Row, row
    end
  end
  
  def test_grid_has_the_right_number_of_rows_and_columns
    assert_equal @grid.device.class.rows * @grid.device.class.columns, @grid.to_a.size
  end
  
  def test_columns
    last_column_number = @grid.columns.size - 1
    assert @grid.columns.first.all? {|led| led.column.zero? }
    assert @grid.columns.last.all? {|led| led.column == last_column_number}
  end
  
  def test_led_indexing
    row, column = 3, 4
    led = @grid[row, column]
    assert_kind_of Monome::LED, led
    assert_equal row, led.row
    assert_equal column, led.column
  end
  
  def test_inverting_the_grid
    assert @grid.leds.all? {|led| led.off? }
    assert_nothing_raised  { @grid.invert  }
    assert @grid.leds.all? {|led| led.on?  }
    assert_nothing_raised  { @grid.invert  }
    assert @grid.leds.all? {|led| led.off? }
  end
  
  [%w(row rows), %w(column columns)].each do |singular, plural|
    define_method("test_turning_an_entire_#{singular}_on_and_off") do
      number = 2
      assert @grid.send(plural)[number].all? {|led| led.off?}
      assert_nothing_raised do
        @grid.send("turn_#{singular}", number, :on)
      end
      assert @grid.send(plural)[number].all? {|led| led.on? }
    end
  end
  
  def test_clearing_the_entire_grid
    @grid.invert
    assert @grid.leds.all? {|led| led.on?}
    assert_nothing_raised do
      @grid.clear
    end
    
    assert_all_clear = lambda do 
      assert @grid.leds.all? {|led| led.off? }
    end
    
    assert_all_clear.call
    
    # Make sure clearing it even when they are all cleared
    # works fine
    assert_nothing_raised do
      @grid.clear
    end
    
    assert_all_clear.call
  end
  
  def test_inspect
    assert_nothing_raised do
      @grid.inspect
    end
  end
end