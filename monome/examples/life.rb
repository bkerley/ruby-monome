require File.join(File.dirname(__FILE__), "..", "lib", "monome")

class Life < Monome::Application
  attr_reader :editing

  every 0.125, :tick  

  on :initialize do
    @editing = true
  end
  
  on :tick do
    if editing
      toggle(0, 7)
    else
      evolve
    end
  end

  on :press do |column, row, state|
    if state == 0
      if column == 7 && row == 0
        @editing = !editing
        grid[row, column] = 0
      end
    else
      toggle(row, column) if @editing
    end
  end
  
  def evolve
    @last_grid_value = grid_value
    device.in_bundle do
      each_cell do |row, column, state|
        if death?(row, column)
          grid[row, column] = 0
        elsif birth?(row, column)
          grid[row, column] = 1
        end
      end
    end
    @editing = true if unchanged?
  end
  
  protected
    attr_reader :last_grid_value
  
    def each_cell
      grid.each_row do |row_data, row|
        row_data.each_with_index do |state, column|
          yield row, column, state
        end
      end
    end
    
    def living_neighbors(row, column)
      neighbors = [-1, 0, 1].map do |offset|
        (grid.row(row + offset) || []).values_at(column - 1, column, column + 1)
      end.flatten
      neighbors.delete_at(4)
      neighbors.select { |neighbor| neighbor == 1 }.length
    end
    
    def death?(row, column)
      !neighbor_sizes_for_life.include? living_neighbors(row, column) if grid[row, column] == 1
    end
    
    def birth?(row, column)
      neighbor_sizes_for_birth.include? living_neighbors(row, column) if grid[row, column] == 0
    end
    
    def grid_value
      grid.to_a
    end
    
    def unchanged?
      grid_value == last_grid_value
    end
    
    def neighbor_sizes_for_life
      options[:neighbor_sizes_for_death] || [2, 3]
    end

    def neighbor_sizes_for_birth
      options[:neighbor_sizes_for_birth] || [3]
    end
end

if __FILE__ == $0
  Life.run(:device => Monome::M40h.new)
end
