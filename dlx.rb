class DLX
  attr_reader :solutions

  def initialize(number_of_columns, array_of_rows = nil)
    @root = Column.new(0)
    @solution = []
    @solutions = []

    setup_columns(number_of_columns)
    array_of_rows.each {|row_array| add_row(row_array)} if array_of_rows
  end

  def solve
    search(0)
  end

  def add_row(row_array)
    added_nodes = []
    @root.traverse(:right) do |column|
      if index = row_array.index(column.label)
        added_nodes[index] = column.add_node
      end
    end

    added_nodes.each_with_index do |node, index|
      node.right = added_nodes[(index+1)%added_nodes.size]
      node.left  = added_nodes[(index-1)%added_nodes.size]
    end
  end

  private
  def search(k)
    if (column = find_smallest_column).nil?
      store_solution
      return true
    end

    column.cover

    column.traverse(:down) do |row|
      @solution[k] = row
      row.traverse(:right) do |node|
        node.column.cover
      end
      search(k+1)
      row = @solution[k]
      row.traverse(:left) do |node|
        node.column.uncover
      end
    end

    column.uncover
  end

  def store_solution
    solution_array = []
    @solution.each do |solution_node|
      row = [solution_node.column.label]
      solution_node.traverse(:right) do |node|
        row << node.column.label
      end
      solution_array << row
    end
    @solutions << solution_array
  end

  def setup_columns(number_of_columns)
    node = @root
    number_of_columns.times do |label|
      node.right = Column.new(label+1)
      node.right.left = node
      node = node.right
    end
    node.right, @root.left = @root, node
  end


  def find_smallest_column
    return nil if (column = @root.right) == @root
    min_size = column.size
    @root.traverse(:right) do |temp_column|
      column, min_size = temp_column, temp_column.size if temp_column.size <= min_size
    end
    return column
  end

  class Node
    attr_accessor :left, :right, :up, :down, :column

    def initialize(column)
      @left = @right = @up = @down = self
      @column = column
    end

    def traverse(direction)
      node = self
      while((node = node.send(direction)) != self)
        yield node
      end
    end

    def cover
      up.down, down.up = down, up
      column.size -= 1
    end

    def uncover
      up.down, down.up = self, self
      column.size += 1
    end
  end

  class Column < Node
    attr_accessor :label, :size

    def initialize(label)
      super(self)
      @label = label
      @size = 0
    end

    def add_node
      bottom = self.up
      bottom.down = Node.new(self)
      bottom.down.up = bottom
      bottom.down.down = self
      self.up = bottom.down
      @size += 1
      bottom.down
    end

    def cover
      right.left, left.right = left, right
      traverse(:down) do |row|
        row.traverse(:right) do |node|
          node.cover
        end
      end
    end

    def uncover
      traverse(:up) do |row|
        row.traverse(:left) do |node|
          node.uncover
        end
      end
      right.left, left.right = self, self
    end
  end
end
