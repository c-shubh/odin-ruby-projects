# frozen_string_literal: true

require 'set'

class Hangman
  # @param words_file_path [String]
  def initialize(words_file_path)
    @secret_word = select_secret_word(get_words(words_file_path))
    @secret_word_set = Set.new(@secret_word.chars)
    @used_letters = Set.new
    @rem_inc_guess = 9
  end

  # Get words from given file path.
  # @param file_path [String]
  # @return [Array<String>]
  def get_words(file_path)
    IO.readlines(file_path, chomp: true)
  end

  # Randomly choose a secret word between 5 and 12 characters long.
  # @param words [Array<String>]
  # @return [String]
  def select_secret_word(words)
    words = words.filter { |word| word.length.between?(5, 12) }
    prng = Random.new
    idx = prng.rand(words.length)
    words[idx]
  end

  # Print the allowed chars of secret word (other chars will be an underscore).
  # @param word [String] the secret word
  # @param allowed_chars [Set<String>] array of characters to print.
  # @return [nil]
  def print_secret_word(word, allowed_chars)
    word.each_char do |char|
      allowed_chars.include?(char) ? (print char) : (print '_')
      print ' '
    end
    puts
  end

  # Input player's guess.
  # return [String] a single character
  def input_guess
    guess = ''
    loop do
      print "\nEnter your guess: "
      guess = gets.strip.downcase
      break if valid_input_guess?(guess)
    end
    guess
  end

  # Check whether the input guess is valid.
  # @param guess [String] a single character
  # @return [Boolean]
  def valid_input_guess?(guess)
    guess.length == 1 \
    && guess.match(/[a-zA-Z]/) \
    && !@used_letters.include?(guess)
  end

  def won_game?
    @rem_inc_guess.positive? \
    && (@secret_word_set - @used_letters).empty?
  end

  def lost_game?
    @rem_inc_guess <= 0
  end

  def play
    print_secret_word(@secret_word, [])
    loop do
      guess = input_guess
      @used_letters << guess
      if @secret_word.include?(guess)
        print_secret_word(@secret_word, (@secret_word_set & @used_letters).to_a)
      else
        @rem_inc_guess -= 1
        puts "Incorrect guess: #{guess}\n" \
             "#{@rem_inc_guess} incorrect guesses remaining."
      end

      if won_game?
        puts 'You won the game.'
        break
      end

      if lost_game?
        puts "Correct word is #{@secret_word}."
        puts 'You lost the game.'
        break
      end
    end
  end
end

hangman = Hangman.new('google-10000-english-no-swears.txt')
hangman.play
