# frozen_string_literal: true

require_relative 'game'

print 'Player X: '
player_x = gets.chomp

print 'Player O: '
player_o = gets.chomp

game = Game.new(player_x, player_o)
game.play
