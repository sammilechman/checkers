require_relative 'board.rb'
require 'io/console'
require 'yaml'

class Checkers

  attr_accessor :other_player, :current_player

  def initialize
    welcome_sequence
  end

  def welcome_sequence
    system("clear")
    puts "Welcome to Ultimate Checkers 5000, Deluxe Version\n\n"
    print "Please enter the first player's name: "
    player1 = gets.chomp.downcase.capitalize
    print "\nPlease enter the second player's name: "
    player2 = gets.chomp.downcase.capitalize
    @current_player, @other_player = Player.new(player1, :white), Player.new(player2, :black)
    @board, @cursor = Board.new, [ 9,0 ]
    gameplay
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

  def gameplay

    until over?
      get_move(@current_player)
    end

  end

  def over?
    false
  end

  def get_move(player)
      error_message = ""
      begin
        move_queue = []
        while true

          x, y = @cursor

          @board.display(@cursor)
          #puts "#{@current_player.name}'s turn."
          puts "\n#{error_message}\n\n"

          puts "To add to your move queue, press 'r'."
          puts "To execute your move queue, press spacebar."
          puts "To save, press 'p'"
          puts "To quit, press '0'\n\n"
          puts "\n#{@current_player.name}'s turn."
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
            if !@board[@cursor].nil? && @board[@cursor].color != @current_player.color
              move_queue = []
              raise "You can't select the opponent's piece."
            end
            move_queue << @cursor
          elsif key == :space
            if move_queue.length < 2
              move_queue = []
              raise "You need to select at least one startpoint and one endpoint."
            end
            if array_moves_bad?(move_queue)
              move_queue = []
              raise "Doesn't look like that's a valid move."
            end
            selected_piece = @board[move_queue.shift]
            if selected_piece.nil?
              move_queue = []
              raise "You can't start from an empty space. Select one of your own pieces."
            end
            selected_piece.move(move_queue)
            move_queue = []
            @current_player, @other_player = @other_player, @current_player

          end
        end

      rescue RuntimeError => e
        error_message = e.message
        retry
      end

    end

    def array_moves_bad?(arr)
      slides = 0
      jumps = 0

      (arr.length - 1).times do |idx|
        #Calculate abs difference to determine if jump or slide.
        diff = (arr[idx][0] - arr[idx + 1][0])
        diff *= -1 if diff < 0

        #Have you jumped? You can't slide. Have you slid? You can't move.
        return true if diff == 2 && slides > 0
        return true if diff == 1 && slides > 0
        return true if diff == 1 && jumps > 0

        slides += 1 if diff == 1
        jumps +=1 if diff == 2
      end
      false
    end

end

class Player
  attr_reader :name, :color
  def initialize(name = "Nameless Checker's Assassin", color)
    @name = name
    @color = color
  end
end

if __FILE__ == $PROGRAM_NAME
  g = Checkers.new
end