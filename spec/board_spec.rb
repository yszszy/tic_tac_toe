# frozen_string_literal: true

require_relative '../lib/board'

RSpec.describe Board do
  subject(:board) { Board.new(3) }

  describe '#initialize' do
    it 'creates board squares' do
      expected_array = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
      expect(board.instance_variable_get(:@squares)).to eq(expected_array)
    end
  end

  describe '#move' do
    it 'marks the square with the symbol' do
      symbol = 'x'
      row = 0
      column = 0
      expect { board.move(symbol, row, column) }.to change { board.instance_variable_get(:@squares)[row][column] }.from(nil).to(symbol)
    end
  end

  describe '#winning_move?' do
  end

  describe '#no_squares_left?' do
    context 'when there are avaliable squares' do
      it 'returns false' do
        expect(board.no_squares_left?).to be false
      end
    end

    context 'when there are  no avaliable squares' do
      it 'returns true' do
        board.instance_variable_get(:@squares).map! { %w[x o x] }
        expect(board.no_squares_left?).to be true
      end
    end
  end

  describe '#square_empty?' do
    context 'when the square is empty' do
      it 'returns true' do
        row = 1
        column = 1
        expect(board.square_empty?(row, column)).to be true
      end
    end

    context 'when the square is already taken' do
      it 'returns true' do
        board.instance_variable_get(:@squares).map! { %w[x o x] }
        expect(board.square_empty?(1, 1)).to be false
      end
    end
  end
end
