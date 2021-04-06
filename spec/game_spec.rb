# frozen_string_literal: true

require_relative '../lib/game'

RSpec.describe Game do
  subject(:game) { described_class.new('Bob', 'Joan') }

  describe '#initialize' do
    it 'creates a new board' do
      expect(Board).to receive(:new)
      subject
    end

    it 'creates two players' do
      expect(Player).to receive(:new).with('Bob', 'x')
      expect(Player).to receive(:new).with('Joan', 'o')
      subject
    end

    it 'chooses a current player' do
      player_x = game.instance_variable_get(:@player_x)
      player_o = game.instance_variable_get(:@player_o)
      expect(game.instance_variable_get(:@current_player)).to eq(player_x).or eq(player_o)
    end

    it 'sets winner to nil' do
      winner = game.instance_variable_get(:@winner)
      expect(winner).to be_nil
    end
  end

  describe '#game_over?' do
    context 'when no squares are left on the board' do
      it 'returns true' do
        board = game.instance_variable_get(:@board)
        allow(board).to receive(:no_squares_left?).and_return(true)
        expect(game.game_over?).to be true
      end
    end

    context 'when there is a winner' do
      it 'returns true' do
        winner = game.instance_variable_get(:@player_x)
        game.instance_variable_set(:@winner, winner)
        expect(game.game_over?).to be true
      end
    end

    context 'when there are some square left and there is no winner' do
      it 'returns false' do
        expect(game.game_over?).to be false
      end
    end
  end

  describe '#display_board' do
    it 'sends display board' do
      board = game.instance_variable_get(:@board)
      expect(board).to receive(:display)
      game.display_board
    end
  end

  describe '#player_input' do
    context 'when player input is invalid' do
      it 'displays invalid input error message' do
        invalid_input = ''
        valid_input = '00'
        allow(game).to receive(:gets).and_return(invalid_input, valid_input)
        expect(game).to receive(:invalid_input_message).once
        game.player_input
      end
    end

    context 'when player input is valid' do
      it 'does not display invalid input error message' do
        valid_input = '20'
        allow(game).to receive(:gets).and_return(valid_input)
        expect(game).not_to receive(:invalid_input_message)
        game.player_input
      end

      context 'when square is already taken' do
        it 'displays square already taken message' do
          valid_inputs = %w[11 10]
          unavaliable_square = [1, 1]
          avaliable_square = [1, 0]
          allow(game).to receive(:gets).and_return(*valid_inputs)
          allow(game).to receive(:avaliable_move?).and_return(nil, avaliable_square)
          expect(game).to receive(:square_already_taken_message).with(*unavaliable_square).once
          game.player_input
        end
      end

      context 'when square is avaliable' do
        let(:valid_input) { '20' }
        let(:avaliable_square) { [2, 0] }

        before do
          allow(game).to receive(:gets).and_return(valid_input)
          allow(game).to receive(:avaliable_move?).and_return(avaliable_square)
        end

        it 'does not display square already taken message' do
          expect(game).not_to receive(:square_already_taken_message)
        end

        it 'returns avaliable square' do
          expect(game.player_input).to eq(avaliable_square)
        end
      end
    end
  end

  describe '#verify_player_input' do
    context 'when player inputs two digits matching the board dimension' do
      it 'returns player input' do
        valid_input = '20'
        expect(game.verify_player_input(valid_input)).to eq(valid_input)
      end
    end

    context 'when player inputs two digits smaller than board dimensions' do
      it 'returns nil' do
        invalid_input = '-11'
        expect(game.verify_player_input(invalid_input)).to be_nil
      end
    end

    context 'when player inputs two digits grater than board dimensions' do
      it 'returns nil' do
        invalid_input = '14'
        expect(game.verify_player_input(invalid_input)).to be_nil
      end
    end

    context 'when player inputs more than two digits' do
      it 'returns nil' do
        invalid_input = '101'
        expect(game.verify_player_input(invalid_input)).to be_nil
      end
    end

    context 'when player inputs less than two digits' do
      it 'returns nil' do
        invalid_input = '0'
        expect(game.verify_player_input(invalid_input)).to be_nil
      end
    end

    context 'when player inputs non digit characters' do
      it 'returns nil' do
        invalid_input = 'm!'
        expect(game.verify_player_input(invalid_input)).to be_nil
      end
    end

    context 'when player input is empty' do
      it 'returns nil' do
        invalid_input = ''
        expect(game.verify_player_input(invalid_input)).to be_nil
      end
    end
  end

  describe '#avaliable_move?' do
    it 'sends message to the board' do
      row = 0
      column = 0
      board = game.instance_variable_get(:@board)
      expect(board).to receive(:square_empty?).with(row, column)
      game.avaliable_move?([row, column])
    end

    context 'when square is empty' do
      it 'returns coordinates' do
        empty_square_coordinates = [1, 1]
        board = game.instance_variable_get(:@board)
        allow(board).to receive(:square_empty?).with(*empty_square_coordinates).and_return(true)
        expect(game.avaliable_move?(empty_square_coordinates)).to eq(empty_square_coordinates)
      end
    end

    context 'when square is already taken' do
      it 'returns nil' do
        taken_square_coordinates = [2, 0]
        board = game.instance_variable_get(:@board)
        allow(board).to receive(:square_empty?).with(*taken_square_coordinates).and_return(false)
        expect(game.avaliable_move?(taken_square_coordinates)).to be_nil
      end
    end
  end

  describe '#move' do
    it 'sends message to the board' do
      row = 2
      column = 1
      current_player_symbol = game.instance_variable_get(:@current_player).symbol
      board = game.instance_variable_get(:@board)
      expect(board).to receive(:move).with(current_player_symbol, row, column)
      game.move([row, column])
    end

    context 'when move made' do
      it 'returns move coordinates' do
        coordinates = [2, 2]
        current_player_symbol = game.instance_variable_get(:@current_player).symbol
        board = game.instance_variable_get(:@board)
        allow(board).to receive(:move).with(current_player_symbol, *coordinates).and_return(coordinates)
        expect(game.move(coordinates)).to eq(coordinates)
      end
    end

    context 'when move not made' do
      it 'returns nil' do
        coordinates = [1, 2]
        current_player_symbol = game.instance_variable_get(:@current_player).symbol
        board = game.instance_variable_get(:@board)
        allow(board).to receive(:move).with(current_player_symbol, *coordinates).and_return(nil)
        expect(game.move(coordinates)).to be_nil
      end
    end
  end

  describe '#win?' do
    context 'when it is a winning move' do
      it 'assings the current player to the winner variable' do
        move = [0, 1]
        board = game.instance_variable_get(:@board)
        current_player = game.instance_variable_get(:@current_player)
        allow(board).to receive(:winning_move?).and_return(true)
        expect { game.win?(move) }.to change { game.instance_variable_get(:@winner) }.from(nil).to(current_player)
      end
    end

    context 'when it is not a winning move' do
      it 'does not assing the current player to the winner variable' do
        move = [0, 1]
        board = game.instance_variable_get(:@board)
        allow(board).to receive(:winning_move?).and_return(false)
        expect { game.win?(move) }.not_to change { game.instance_variable_get(:@winner) }
      end
    end
  end

  describe '#switch_player' do
    it 'switches current player' do
      player = game.instance_variable_get(:@current_player)
      game.switch_player
      expect(game.instance_variable_get(:@current_player)).not_to eq(player)
    end
  end

  describe 'game_over_message' do
    context 'when there is a winner' do
      it 'displays a congratulations message' do
        winner = game.instance_variable_get(:@player_o)
        game.instance_variable_set(:@winner, winner)
        expect(game).to receive(:congratulations_message)
        game.game_over_message
      end
    end

    context 'when there is no winner' do
      it 'displays a tie message' do
        expect(game).to receive(:tie_message)
        game.game_over_message
      end
    end
  end
end
