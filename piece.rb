class Piece
  attr_reader :color, :position
  attr_accessor :position, :king

  def initialize(board, position, color, king = false)
    @board = board
    @position = position
    @color = color
    @king = king
  end

  def move_list
    list = []
    self.deltas.each do |delta|
      new_pos = [(delta[0] + @position[0]), (delta[1] + @position[1])]
      list << new_pos if on_board?(new_pos)
    end
    list
  end

  def deltas
    list = []
    list << [ -1, -1 ] << [ -1, 1 ] if color == :white || king == true
    list << [ 1, -1 ] << [ 1, 1 ] if color == :black || king == true
    list
  end

  def on_board?(pos)
    pos[0] >= 0 && pos[0] <= 9 && pos[1] >= 0 && pos[1] <= 9
  end

  def occupied_checker(pos)
    enemy_color = (@color == :white) ? :black : :white
    return :none if @board[pos].nil?
    return enemy_color.to_sym if @board[pos].color == enemy_color
    return @color.to_sym if @board[pos].color == @color
  end

  def get_sprite
    return "W " if color == :white
    return "B " if color == :black
  end


end