require "set"

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def pink
    colorize(35)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def light_blue
    colorize(36)
  end
end

class Ghost
  attr_reader :fragment

  def initialize(player_1, player_2)
    @current_player = "player_1"
    @previous_player = "player_2"
    @dictionary = File.open("dictionary.txt").read.split("\n").to_set
    @fragment = ""
    @round = 1
    @losses = {
      "player_1" => 0,
      "player_2" => 0
    }
  end

  def play_round
    start_round

    until round_over?
      display_fragment
      take_turn(@current_player)
      next_player!
    end

    end_round
  end

  def start_round
    @fragment = ""
    puts "\nRound# #{@round}".green
  end

  def round_over?
    @dictionary.include?(@fragment) || @fragment == "game over"
  end

  def display_fragment
    puts "\n" + @fragment.upcase.pink + "\n\n"
  end

  def take_turn(player)
    puts "#{player} enter a char".light_blue
    char = gets.chomp

    valid_play?(char) ? @fragment += char : @fragment = "game over"
  end

  def valid_play?(char)
    return false if char.length != 1
    new_fragment = @fragment + char
    @dictionary.any? { |word| word.index(new_fragment) == 0 }
  end

  def next_player!
    @current_player, @previous_player = @previous_player, @current_player
  end

  def end_round
    @losses[@previous_player] += 1
    @round += 1
    puts "#{@current_player} won the round".light_blue
    display_standings
  end

  def display_standings
    ghost = "GHOST"

    @losses.each do|k, v| 
      puts "#{k}: #{ghost[0...v]}"
    end
  end

  def run
    until @losses.has_value?(5)
      play_round
    end
    puts "\n\n\nGAME OVER".red
  end
end

class Player
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def guess
    
  end
end

game = Ghost.new(1,2)
game.run
