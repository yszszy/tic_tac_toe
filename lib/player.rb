# frozen_string_literal: true

# Define player class
class Player
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end
