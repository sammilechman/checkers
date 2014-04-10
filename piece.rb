class Piece
  attr_reader :color, :position
  attr_accessor :position, :king

  def initialize(board, position, color, king = false)
    @board = board
    @position = position
    @color = color
    @king = king
  end

  def make_one_move(end_pos)
    type_of_move = slide_move_list.include?(end_pos) ? :slide : :jump

    attempt_slide(@position, end_pos) if type_of_move == :slide
    attempt_jump(@position, end_pos) if type_of_move == :jump

  end

  def attempt_slide(start_pos, end_pos)
    @board[end_pos] = @board[start_pos]
    @board[start_pos] = nil
  end

  def attempt_jump(start_pos, end_pos)

  end

  def slide_move_list
    list = []

    self.deltas.each do |delta|
      new_pos = [(delta[0] + @position[0]), (delta[1] + @position[1])]
      list << new_pos if (on_board?(new_pos) && occupied_checker(new_pos) == :none)
    end
    list
  end

  def jump_move_list
    list = []

    self.deltas.each do |delta|
      new_pos = [(delta[0] + @position[0]), (delta[1] + @position[1])]
      enemy_color = (@color == :white) ? :black : :white
      if occupied_checker(new_pos) == enemy_color
        new_pos = [(delta[0] * 2 + @position[0]), (delta[1] * 2 + @position[1])]
        list << new_pos if (on_board?(new_pos) && occupied_checker(new_pos) == :none)
      end
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