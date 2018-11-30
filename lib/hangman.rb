class Game
  attr_reader :revealed_letters, :random_word, :guesses_remaining, :guesses

  def initialize(game_type)
    @random_word = ""
    @guesses_remaining = 6
    @guesses = []
    @correct_guess = false
    generate_word()
  end

  def play(guess)
    @correct_guess = false
    if good_guess?(guess)
      @guesses << guess
      reveal_letters(guess)
      @guesses_remaining -= 1 unless @correct_guess
    end
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

end
