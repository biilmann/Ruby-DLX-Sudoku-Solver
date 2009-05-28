require "dlx"

class SudokuSolver  
  attr_reader :puzzle, :solutions
  
  def initialize(puzzle)
    @dlx = DLX.new(324)
    @puzzle = puzzle
    @solutions = []
  end
  
  def solve
    setup_sparse_matrix
    @dlx.solve
    convert_solutions
  end
  
  private
  def setup_sparse_matrix
    9.times do |row|
      9.times do |column|
        1.upto 9 do |digit|
          box = (row / 3).floor * 3 + (column / 3).floor
          dlx_row = [row*9 + column + 1]
          dlx_row << 81 + row*9 + digit
          dlx_row << 81 + 81 + column*9 + digit
          dlx_row << 81 + 81 + 81 + box*9 + digit
          @dlx.add_row(dlx_row) unless( @puzzle[row][column] > 0 && @puzzle[row][column] != digit )
        end
      end
    end
  end
  
  def convert_solutions
    return if @dlx.solutions.size == 0
    solution_matrix = [[],[],[],[],[],[],[],[],[]]
    @dlx.solutions.each_with_index do |solution,index|
      solution.each do |dlx_row|
        dlx_row.sort!
        row = ((dlx_row[0]-1)/9).floor
        column = (dlx_row[0]-1)%9
        solution_matrix[row][column] = dlx_row[1]-81-(row*9)
      end
      @solutions << solution_matrix
    end
  end
end