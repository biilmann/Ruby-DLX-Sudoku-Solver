Ruby DLX Based Sudoku Solver
----------------------------

This is a small DLX based sudoku solver made in Ruby. DLX, or Dancing Links X is an algorithm for solving exact cover problems by brute force, taking advantage of a clever way of juggling around with the pointers in a sparse matrix of doubly linked list.

The original paper is available at [arxiv.org](https://arxiv.org/abs/cs/0011047).

The two important files in this repository is dlx.rb - a general implementation of the DLX constraint solving algorithm, and sudoku_solver.rb - which does the setup of the sparse matrix for a given sudoku and translates from the dlx result to a sudoku solution.

The solver (extracted into a C extension) is used to generate the sudokus at my simple [sudoku challenge](http://sudoku.mathias-biilmann.net) challenge page.
