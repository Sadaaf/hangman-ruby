require 'open-uri'

DATA_URL = "https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt"
FILE_NAME = "words.txt"

unless File.exist?(FILE_NAME)
  URI.open(DATA_URL) do |file|
    File.write(FILE_NAME, file.read)
  end
end

# Load the words from the file and choose 5 random words
# A counter for total_guesses
# An array with the letters that have been guessed wrong
# An array with the letters that have been guessed right
# counter of total_guesses - number of letters guessed = number of guesses left
# A method to check if the letter guessed is in the word
# A method to check if the word has been guessed
# A method to check if the game is over
# A method to display the word with the letters that have been guessed
# A method to display the letters that have been guessed wrong
class Hangman
  def initialize
    @word = File.readlines(FILE_NAME).map(&:chomp).select{|word| word.length.between?(5,12)}.sample().split("")
    @total_guesses = 10
    @wrong_guesses = []
    @right_guesses = Array.new(@word.length, '_')
  end

  def play
    for i in 1..@total_guesses
      guess
      newline
      break if !@right_guesses.include?('_')
      puts "Your previous wrong guesses were: #{@wrong_guesses}"
    end
    if @right_guesses.join.casecmp?(@word.join)
      puts "You won!"
    else
      puts "GAME OVER! You failed to guess the word"
      puts "The correct word was: #{@word.join}"
    end
  end

  private

  def guess
    puts "Guess a letter"
    letter = gets.chomp
    indexes = @word.each_index.select { |index| @word[index] == letter}
    if indexes.length > 0
      indexes.each do |index|
        @right_guesses[index] = letter
      end      
        p @right_guesses
    else
        @wrong_guesses << letter
    end
  end

  def newline
    puts "\n\n\n\n\n\n\n\n\n\n\n\n"
  end
end

hangman = Hangman.new
hangman.play