require 'sudoku_solver'

sudoku = [
  [0,0,9,7,0,8,4,0,0],
  [0,1,0,0,0,0,0,8,0],
  [0,0,5,0,0,0,2,0,0],
  [0,2,0,5,0,9,0,3,0],
  [0,5,0,2,8,3,0,7,0],
  [0,9,0,4,0,1,0,6,0],
  [0,0,7,0,0,0,1,0,0],
  [0,3,0,0,0,0,0,2,0],
  [0,0,2,9,0,5,3,0,0]
]

solver = SudokuSolver.new(sudoku)

solver.solve

solver.solutions.each do |solution|
  puts "Solution found"
  solution.each do |row|
    puts row.join(' ')
  end
end
