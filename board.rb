require_relative 'piece.rb'

class Board
  attr_accessor :rows

  def initialize(new = true)
    @rows = Array.new(10) { Array.new(10) }
    set_pieces if new
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

  def display(cursor)
    system("clear")
    counter = 0
    puts "   0 1 2 3 4 5 6 7 8 9"
    @rows.each_with_index do |row, idx|
      print "#{idx} "
      row.each_with_index do |tile, idx2|
        background = counter.odd? ? :lr : :lb
        sprite = tile.nil? ? "  " : tile.get_sprite

        print sprite.on_light_red if background == :lr && cursor != [idx, idx2]
        print sprite.on_light_black if background == :lb && cursor != [idx, idx2]

        print sprite.on_magenta if background == :lr && cursor == [idx, idx2]
        print sprite.on_magenta if background == :lb && cursor == [idx, idx2]


        counter += 1
      end
      puts
      counter += 1
    end
    nil
  end

  def inspect
    " "
  end

end