require 'open-uri'
require 'json'

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
    @attempts = 0
  end

  def play
    puts "Input 1 to load game"
    puts "Input 2 to start a new game"
    input = get_choice([1,2])
    load_game if input == 1
    start_game
  end

  private

  def start_game
    for i in @attempts..@total_guesses
      @attempts = i
      puts "You have #{@total_guesses - i} guesses left"
      puts "Your previous correct guesses were: #{@right_guesses}"
      newline
      puts "Your previous wrong guesses were: #{@wrong_guesses}"
      newline
      guess
      newline
      break if !@right_guesses.include?('_')
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
    puts "To save progress input 1"
    puts "To continue without saving inout 2"
    input = get_choice([1,2])
      if input == 1
        save_game
      end
  end

  def save_game
    Dir.mkdir("save") unless Dir.exist?("save")
    File.open("./save/#{Time.now.strftime("%H-%M-%S")}.txt", "w") do |save_file|
      save_file.write("#{@right_guesses}\n#{@wrong_guesses}\n#{@attempts+1}\n#{@word}")
    end
    puts "Game Saved"
  end

  def load_game
    available_saves = 0
    save_file_names = []
    if Dir.exist?("save") && !Dir.empty?("save")
      Dir.entries("save").each_with_index do |entry, index|
        next if entry == "." || entry == ".."
        puts "#{index-1}. #{entry}"
        save_file_names << entry
        available_saves = index-1
      end
      puts "Please select a save file to load"
      selected = get_choice((1..available_saves).to_a)
      save = File.readlines("save/#{save_file_names[selected-1]}")
      @right_guesses = JSON.parse(save[0])
      @wrong_guesses = JSON.parse(save[1])
      @attempts = save[2].to_i
      @word = JSON.parse(save[3])
    else
      puts "You don't have any saved games"
    end
  end

  def get_choice choices
    input = gets.chomp.to_i 
    until choices.include?(input)
      puts "Invalid input! please input #{choices.join(", ")}"
      input = gets.chomp.to_i 
    end
    return input
  end

  def newline
    puts "\n\n"
  end
end

hangman = Hangman.new
hangman.play