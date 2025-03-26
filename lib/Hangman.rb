require 'open-uri'

DATA_URL = "https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt"
FILE_NAME = "words.txt"

unless File.exist?(FILE_NAME)
  URI.open(DATA_URL) do |file|
    File.write(FILE_NAME, file.read)
  end
end

class Hangman
  def initialize
    @word = File.readlines(FILE_NAME).map(&:chomp).select{|word| word.length.between?(5,12)}.sample().downcase().split("")
    @total_guesses = 12
    @wrong_guesses = []
    @right_guesses = Array.new(@word.length, '_')
  end

  def play
    puts "Input 1 to load game"
    puts "Input 2 to start a new game"
    input = gets.chomp.to_i 
    until input >= 1 && input <= 2
      puts "Invalid input! Please enter 1 or 2"
      input = gets.chomp.to_i 
    end
    load_game if input == 1
    start_game if input == 2
  end

  private

  def start_game
    for i in 1..@total_guesses
      puts "You have #{@total_guesses - i + 1} guesses left"
      guess
      newline
      break if !@right_guesses.include?('_')
      newline
      puts "Your previous correct guesses were: #{@right_guesses}"
      newline
      puts "Your previous wrong guesses were: #{@wrong_guesses}"
      newline
    end
    if @right_guesses.join.casecmp?(@word.join)
      puts "You won!!!!! #{@word.join} is correct"
    else
      puts "GAME OVER! You failed to guess the word"
      puts "The correct word was: #{@word.join}"
    end
  end

  def guess
    puts "Guess a letter"
    letter = gets.chomp.downcase
    indexes = @word.each_index.select { |index| @word[index] == letter}
    if indexes.length > 0
      indexes.each do |index|
        @right_guesses[index] = letter
      end
    else
        @wrong_guesses << letter
    end
  end

  def save_game
    puts "Game Saved"
  end

  def load_game
    puts "Game Loaded"
  end

  def newline
    puts "\n\n"
  end
end

hangman = Hangman.new
hangman.play