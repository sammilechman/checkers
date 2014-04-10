require_relative 'board.rb'
require 'io/console'
require 'yaml'

class Checkers

  attr_accessor :cursor_start_position, :cursor_end_position

  def initialize
    welcome_sequence
  end

  def welcome_sequence
    puts "Welcome to Ultimate Checkers 5000, Deluxe Version\n\n"
    print "Please enter the first player's name: "
    player1 = gets.chomp.downcase.capitalize
    print "\nPlease enter the second player's name: "
    player2 = gets.chomp.downcase.capitalize
    @player1, @player2, @board, @cursor = player1, player2, Board.new, [ 9,0 ]
    get_move
  end

  def get_cursor_input
    key = $stdin.getch.downcase
    return :up if key == 'w'
    return :down if key == 's'
    return :left if key == 'a'
    return :right if key == 'd'
    return :select if key == 'r'
    return :space if key == ' '
    #save_game if key == 'p'
    exit if key == '0'
  end

  def get_move
      error_message = ""
      move_queue = []
      begin

      while true
        x, y = @cursor

        @board.display(@cursor)
        #puts "#{@current_player.name}'s turn."
        puts "\n#{error_message}\n\n"

        puts "To add to your move queue, press 'r'."
        puts "To execute your move queue, press spacebar."
        puts "To save, press 'p'"
        puts "To quit, press '0'\n\n"
        puts "Your move queue: #{move_queue}."

        key = get_cursor_input
        error_message = ""
        if key == :up
          @cursor = [x - 1, y] unless x == 0
        elsif key == :down
          @cursor = [x + 1, y] unless x == 9
        elsif key == :left
          @cursor = [x, y - 1] unless y == 0
        elsif key == :right
          @cursor = [x, y + 1] unless y == 9
        elsif key == :select
          move_queue << @cursor
        elsif key == :space
          selected_piece = @board[move_queue.shift]
          until move_queue.empty?
            selected_piece.move([move_queue.shift])
          end
        end
      end

      rescue RuntimeError => e
        @cursor_start_position = nil
        @cursor_end_position = nil
        error_message = e.message
        retry
      end

    end

end

class Player
  def initialize(name = "Player 1")
    @name = name
  end
end

if __FILE__ == $PROGRAM_NAME
  g = Checkers.new
end