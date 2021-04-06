# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

class Game
  def initialize(player_x, player_o)
    @board = Board.new
    @player_x = Player.new(player_x, 'x')
    @player_o = Player.new(player_o, 'o')
    @current_player = [@player_x, @player_o].sample
    @winner = nil
  end

  def play
    until game_over?
      display_current_player
      display_board
      move = move(player_input)
      win?(move)
      switch_player
    end

    display_board
    game_over_message
  end

  def game_over?
    @board.no_squares_left? || !@winner.nil?
  end

  def display_board
    @board.display
  end

  def player_input
    loop do
      player_input = gets.chomp
      verified_player_input = verify_player_input(player_input)
      next invalid_input_message unless verified_player_input

      coordinates = verified_player_input.split('').map(&:to_i)
      return coordinates if avaliable_move?(coordinates)

      square_already_taken_message(*coordinates)
    end
  end

  def verify_player_input(player_input)
    player_input if /^[0-#{@board.dimension - 1}]{2}$/.match?(player_input)
  end

  def avaliable_move?(coordinates)
    coordinates if @board.square_empty?(*coordinates)
  end

  def move(coordinates)
    coordinates if @board.move(@current_player.symbol, *coordinates)
  end

  def win?(move)
    @winner = @current_player if @board.winning_move?(@current_player.symbol, *move)
  end

  def switch_player
    @current_player = @current_player == @player_x ? @player_o : @player_x
  end

  def game_over_message
    @winner ? congratulations_message : tie_message
  end

  private

  def display_current_player
    puts "#{@current_player.name} #{@current_player.symbol}: "
  end

  def invalid_input_message
    puts "Enter square coordinates in such a form: xy (where x and y are >= 0 and < #{@board.dimension}"
  end

  def square_already_taken_message(row, column)
    puts "Square [#{row}][#{column}] already taken"
  end

  def congratulations_message
    puts "The winner is: #{@winner.name}. Congratsss!!!"
  end

  def tie_message
    puts 'We have a tie...'
  end
end
