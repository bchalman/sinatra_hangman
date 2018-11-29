require 'yaml'
# require './lib/player.rb'

class Game
  attr_reader :revealed_letters, :random_word, :guesses_remaining, :guesses #, :player

  def initialize(game_type)
    @random_word = ""
    @guesses_remaining = 6
    # @player = Player.new
    @guesses = []
    @correct_guess = false
    # welcome()
    # game_type = get_game_type()
    generate_word()
    load_game() if game_type == "load"
#    play
  end

  def play(guess)
#    while @guesses_remaining > 0
#      populate_display()
      @correct_guess = false
      if good_guess?(guess)
        @guesses << guess
        reveal_letters(guess)
        @guesses_remaining -= 1 unless @correct_guess
      end
      game_over?
  #  end
  end


  def save_game
    @game_saved = true
    Dir.mkdir("saves") unless Dir.exists?("saves")

    data = [@random_word, @guesses_remaining, @revealed_letters, @guesses]

    puts "Name your save file:"
    file_name = "saves/#{gets.chomp}.yaml"
    File.open(file_name, 'w') do |file|
      file.puts YAML::dump(data)
    end
    puts "Game saved."
    puts "Exiting game..."
    end_game_quietly()
  end

  def load_game
    puts "Listing all saved games:"

    saves = Dir.entries("saves").reject {|file| File.directory?(file)}
    if saves.empty?
      puts "There are no saved games. Proceeding with a new game..."
      return
    end
    saves.each { |save_file| puts "  " + save_file[0...-5] }

    puts "\nPlease select which game to load:"
    choice = gets.chomp + ".yaml"
    until saves.include?(choice)
      puts "Invalid selection. Please enter one of the previous saves exactly."
      choice = gets.chomp + ".yaml"
    end

    data = ""

    File.open("saves/#{choice}", 'r') do |file|
      data = YAML::load(file)
    end

    set_game_values(data)
  end

  def set_game_values(data)
    @random_word = data[0]
    @guesses_remaining = data[1]
    @revealed_letters = data[2]
    @guesses = data[3]
  end

  def game_over?
    # return if @guesses_remaining <= -1
    if @revealed_letters.join("") == @random_word
      # win_message()
      redirect '/win'
    elsif @guesses_remaining == 0
      # lose_message()
      redirect '/lose'
    end
  end

  def reveal_letters(guess)
    # if guess == @random_word
    #   win_message()
    # end
    @random_word.chars.each_with_index do |char, index|
      if guess == char
        @revealed_letters[index] = char
        @correct_guess = true
      end
    end
  end

  def generate_word
    words = File.open("./public/5desk.txt", "r").readlines
        .map{ |word| word.strip }
        .select { |word| word.length.between?(5, 12) }
        .select { |word| !(word =~ /[A-Z]/) }
    @random_word = words.sample
    @revealed_letters = Array.new(@random_word.length, "_")
  end

  # def populate_display
  #   puts "\nGuess the #{@random_word.length}-letter word!"
  #   if @guesses_remaining > 1
  #     puts "You have #{@guesses_remaining} guesses left."
  #   else
  #     puts "You have #{@guesses_remaining} guess left"
  #   end
  #   puts "Previous guesses: #{@player.guesses.join(',')}" if @guesses_remaining < 7
  #   puts
  #   puts "  " + @revealed_letters.join(" ")
  #   puts
  #   puts "Choose a letter:"
  # end

  # def win_message
  #   puts "You win!"
  #   @guesses_remaining = 0
  # end
  #
  # def lose_message
  #   puts "You're out of guesses... You lose :("
  #   puts "The word was #{@random_word}."
  # end

  def end_game_quietly
    @guesses_remaining = -1
  end

  # def welcome
  #   puts "Welcome to Hangman"
  #   puts
  #   puts "Rules:"
  #   puts " - The computer will generate a random word, which you need to guess."
  #   puts " - The word to guess will be represented by a row of dashes, each dash representing a letter."
  #   puts " - Each turn, the player can guess individual letters or the entire word."
  #   puts " - A successful letter guess will populate the appropriate display dashes with the chosen letter."
  #   puts " - An incorrect guess will be a mark against the player."
  #   puts " - Guessing the entire word correctly or filling in all the blanks means you win!"
  #   puts " - Six incorrect guesses, and you lose!"
  #   puts
  #   puts "Options:"
  #   puts " - At any time during play, input '1' to save your game and exit."
  #   puts
  #   puts "Input '1' to start a new game, or '2' to load a game:"
  # end

  def good_guess?(guess)
    return false if @guesses.include?(guess)
    true
  end

  def get_game_type
    choice = gets.chomp
    until choice == "1" || choice == "2"
      puts "Invalid input. Please enter '1' to start a new game, or '2 to load an existing game'."
      choice = gets.chomp
    end
    choice
  end
end

# play_again = "y"
# while play_again == "y"
#   game = Game.new()
#   puts "Would you like to play again? (y/n)"
#   play_again = gets.chomp.downcase
#   until play_again == "y" || play_again == "n"
#     puts "Invalid entry. Please enter 'y' to play again, or 'n' to exit."
#     play_again = gets.chomp.downcase
#   end
# end
