require_relative 'piece.rb'

class Board
  attr_accessor :rows

  def initialize(new = true)
    @rows = Array.new(10) { Array.new(10) } if new
    set_pieces
  end

  def set_pieces
    set_one_players_pieces(0, :black)
    set_one_players_pieces(6, :white)
  end

  def set_one_players_pieces(start_row, color)
    counter = 0
    4.times do |x|
      x += 6 if color == :white
      @rows[x].each_with_index do |tile, idx|
        @rows[x][idx] = Piece.new(self, [x, idx], color) if counter.odd?
        counter += 1
      end
      counter += 1
    end
  end

  def [](pos)
    x, y = pos
    @rows[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    @rows[x][y] = piece
  end

  def display
    @rows.each do |row|
      row.each do |tile|
        print "  " if tile.nil?
        print tile.get_sprite if !tile.nil?
      end
      puts
    end
    nil
  end



end