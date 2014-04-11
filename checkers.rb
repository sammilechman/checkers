require_relative 'board.rb'
require 'io/console'
require 'yaml'

class Checkers

  attr_accessor :other_player, :current_player, :board

  def initialize
    welcome_sequence
  end

  def welcome_sequence
    system("clear")
    puts "Welcome to Ultimate Checkers 5000, Deluxe Version\n\n"
    print "Would you like to load a saved game or start a new one? Type 'L' or 'N': "
    input = gets.chomp.downcase
    if input == 'n'
      print "\nPlease enter the first player's name: "
      player1 = gets.chomp.downcase.capitalize
      print "\nPlease enter the second player's name: "
      player2 = gets.chomp.downcase.capitalize
      @current_player, @other_player = Player.new(player1, :white), Player.new(player2, :black)
      @board, @cursor = Board.new, [ 9,0 ]
      gameplay
    elsif input == 'l'
      print "Enter the saved game you would like to play: "
      load_game = gets.chomp.downcase
      load_save(load_game)
    else
      welcome_sequence
    end
  end

  def get_cursor_input
    key = $stdin.getch.downcase
    return :up if key == 'w'
    return :down if key == 's'
    return :left if key == 'a'
    return :right if key == 'd'
    return :select if key == 'r'
    return :space if key == ' '
    save_game if key == 'p'
    exit if key == '0'
  end

  def gameplay

    until over?
      get_move(@current_player)
    end

    puts "#{@winner} wins the game!"

    sleep(4)

  end

  def over?
    black_count, white_count = 0, 0
    @board.pieces.each do |x|
      white_count += 1 if x.color == :white
      black_count += 1 if x.color == :black
    end
    if white_count == 0
      @winner = "Black"
      return true
    elsif black_count == 0
      @winner = "White"
      return true
    end
  end

  def save_game
    puts "Please enter a name for your saved game:"
      filename = gets.chomp.downcase
      File.open("saved_games/#{filename}.yml", 'w') do |f|
        f.puts self.to_yaml
      end
      exit
  end

  def load_save(load_game)
      game_file = File.read("saved_games/#{load_game}.yml")
      game = YAML::load(game_file)
      @board = game.board
      @current_player = game.current_player
      @other_player = game.other_player
      @cursor = [9, 0]
      gameplay
  end

  def get_move(player)
      error_message = ""
      begin
        move_queue = []
        while true

          x, y = @cursor

          @board.display(@cursor)
          puts "\n#{error_message}\n\n"

          puts "To add to your move queue, press 'r'."
          puts "To execute your move queue, press spacebar."
          puts "To save, press 'p'"
          puts "To quit, press '0'\n\n"
          puts "\n#{@current_player.name}'s turn (#{current_player.color})"
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