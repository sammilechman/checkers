require_relative 'piece.rb'

class Board
  attr_accessor :rows

  def initialize(new = true)
    @rows = Array.new(10) { Array.new(10) } if new
  end

  def set_pieces

  end

  def [](pos)
    x, y = pos
    @rows[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    @rows[x][y] = piece
  end



end