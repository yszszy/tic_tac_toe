# frozen_string_literal: true

class Board
  DEFAULT_DIMENSION = 3

  attr_reader :dimension

  def initialize(dimension = DEFAULT_DIMENSION)
    @dimension = dimension
    @squares = Array.new(dimension) { Array.new(dimension) }
  end

  def display
    @squares.each do |row|
      print "\t"
      puts row.to_s
    end
    print "\n"
  end

  def move(symbol, row, column)
    @squares[row][column] = symbol
  end

  def winning_move?(symbol, row, column)
    wins_horizontally?(symbol, row) || wins_vertically?(symbol, column) || wins_diagonally?(symbol)
  end

  def no_squares_left?
    @squares.flatten.none?(&:nil?)
  end

  def square_empty?(row, column)
    @squares[row][column].nil?
  end

  private

  def wins_horizontally?(symbol, row)
    @squares[row].all? { |s| s == symbol }
  end

  def wins_vertically?(symbol, column)
    @squares.map { |row| row[column] }.all? { |s| s == symbol }
  end

  def wins_diagonally?(symbol)
    [@squares, @squares.reverse].any? do |diagonal| 
      diagonal.each_with_index.map { |row, i| row[i] }.all? { |a| a == symbol }
    end
  end
end
