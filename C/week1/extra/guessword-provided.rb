## Provided code for Guess The Word practice problem

class GuessTheWordGame
  def initialize secret_word_class
    @secret_word_class = secret_word_class
    @game_over = false
    @secret_word_entered = false
    @mistakes_allowed = 9
  end

  def play
    puts "Welcome to Guess The Word!"
    while !@game_over
      tick!
    end
    if @secret_word.is_solved?
      puts "Congratulations, you won."
    else
      puts "Sorry, but you failed to guess the word."
      puts "It was:"
      puts @secret_word.word
    end
    puts "Thank you for playing."
  end

  private

  def tick!
    if @secret_word_entered
      ask_for_guessed_letter #asks for guess from player 2
    else
      ask_for_secret_word #asks for secret word from player 1
    end
  end
  
=begin
gets method reads user input. Then program starts waiting for you to type
something with your keyboard & press the enter key.You get back a string.
chomp method changes the results of gets by removing the newline character
at the end of string which has added when pressing enter.
gets (= Kernel.gets) returns (and assigns to $_) the next line from the list of
files in ARGV (or $*), or from standard input if no files are present on the
command line. If ARGV is empty, gets would be enough, but since ARGV is
not empty need to use STDIN.gets.
=end
  
  def ask_for_secret_word
    puts "Enter the secret word of phrase:"
    word = STDIN.gets.chomp
    if is_valid_secret_word? word
      @secret_word_entered = true
    end
  end

  def ask_for_guessed_letter
    puts "Secret word:"
    puts @secret_word.pattern #e.g. displays A-a-, ---- ------!
    puts @mistakes_allowed.to_s + " incorrect guess(es) left."
    puts "Enter the letter you want uncovered:"
    letter = STDIN.gets.chomp
    if @secret_word.valid_guess? letter
      if !@secret_word.guess_letter! letter
        @mistakes_allowed -= 1
        @game_over = @mistakes_allowed == 0
      else
        @game_over = @secret_word.is_solved?
      end
    else
      puts "I'm sorry, but that's not a valid letter."
    end
  end

  #initialize secret_word as instance of secret_word_class with given word
  def is_valid_secret_word? word
    @secret_word = @secret_word_class.new word
    #checks is solved
    !@secret_word.is_solved?
  end
end

class SecretWord
  attr_accessor :word, :pattern

  def initialize word
    self.word = word
    self.pattern = '-' * self.word.length
  end

  #pattern keeps changing till it is same as word, then game is solved
  def is_solved?
    self.word == self.pattern
  end

  # valid guess is 1 char long
  def valid_guess? guess
    guess.length == 1
  end

  def guess_letter! letter
    # String.index returns the integer index of the first match for the given
    # letter else nil
    found = self.word.index letter
    if found
      start = 0
      # index begins searching at position start
      while ix = self.word.index(letter, start)
        #updates pattern with word letters at index found
        self.pattern[ix] = self.word[ix]
        #increments start to keep searching for same letter
        start = ix + 1
      end
    end
    found #produce found bool if letter inside word 
  end
end
