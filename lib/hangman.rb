require 'yaml'

class Game
  attr_reader :revealed_letters, :random_word, :guesses_remaining, :guesses

  def initialize(game_type)
    @random_word = ""
    @guesses_remaining = 6
    @guesses = []
    @correct_guess = false
    generate_word()
    load_game() if game_type == "load"
  end

  def play(guess)
    @correct_guess = false
    if good_guess?(guess)
      @guesses << guess
      reveal_letters(guess)
      @guesses_remaining -= 1 unless @correct_guess
    end
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
    return true if @revealed_letters.join("") == @random_word || @guesses_remaining == 0
    false
  end

  def reveal_letters(guess)
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

  def end_game_quietly
    @guesses_remaining = -1
  end

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
