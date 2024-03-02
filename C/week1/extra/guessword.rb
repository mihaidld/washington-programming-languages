=begin

Guess The Word

We'll toy a bit with a simple word guessing game (known under the rather morbid
name of "Hangman"). Our implementation has a simple text-based interface, and
doesn't aim to be fully playable -- it doesn't make much effort to hide the
secret word or phrase from the player, for example.

Save the provided code implementing a particularly half-baked version of the
game in a file named guessword-provided.rb, put the template solution file
nearby (current file), inspect the code, run the game, and play a little.
Use the template solution file to implement the changes described below.
Note that you should only change the template file.

Change 1: Ignore Punctuation
The first player may enter a phrase or sentence instead of a single word.
The current implementation doesn't treat spaces or punctuation marks in any
special way. Change the game so that punctuation marks and spaces are not hidden
from the second player. You should also reject non-letter characters as guesses.

Change 2: Case Insensitivity
The game currently treats lowercase and uppercase letters as being different.
Change that so that entering either a lowercase or an uppercase letter as a
guess would uncover all the corresponding letters in the secret word or phrase,
regardless of their case.

NOTE: You shouldn't just convert both the secret word and the guesses to lower
or upper case -- that's not neat.

Change 3: Forgive Repeated Guesses
Player may try to guess the same letter absent from the secret phrase multiple
times. The current implementation will consider all such guesses to be incorrect
and reduce the number of remaining attempts accordingly. Change the game so that
repeated guesses are rejected as invalid instead.

EXAMPLE: After implementing all the changes described above, a sample game
session could look as follows:

Welcome to Guess The Word!
Enter the secret word of phrase:
Alas, poor Yorick!
Secret word:
----, ---- ------!
9 incorrect guess(es) left.
Enter the letter you want uncovered:
A
Secret word:
A-a-, ---- ------!
9 incorrect guess(es) left.
Enter the letter you want uncovered:
y
Secret word:
A-a-, ---- Y-----!
9 incorrect guess(es) left.
Enter the letter you want uncovered:
a
I'm sorry, but that's not a valid letter.
Secret word:
A-a-, ---- Y-----!
9 incorrect guess(es) left.
Enter the letter you want uncovered:
,
I'm sorry, but that's not a valid letter.
Secret word:
A-a-, ---- Y-----!
9 incorrect guess(es) left.

=end

## Solution template for Guess The Word practice problem

require_relative './guessword-provided'

class ExtendedGuessTheWordGame < GuessTheWordGame

  # override initialize to keep track of wrong guesses
  def initialize secret_word_class
    super
    @wrong_guesses = []
  end

  # override to check if wrong guess already used
  def ask_for_guessed_letter
    puts "Secret word:"
    puts @secret_word.pattern #e.g. displays A-a-, ---- ------!
    puts @mistakes_allowed.to_s + " incorrect guess(es) left."
    puts "Enter the letter you want uncovered:"
    letter = STDIN.gets.chomp
    # check for valid guess and not repeated
    if @secret_word.valid_guess? letter and !@wrong_guesses.include?(letter.downcase)
      if !@secret_word.guess_letter! letter
        @mistakes_allowed -= 1
        @game_over = @mistakes_allowed == 0
        
        #store wrong guesses in lowercase
        @wrong_guesses.push(letter.downcase)
      else
        @game_over = @secret_word.is_solved?
      end
    else
      puts "I'm sorry, but that's not a valid letter."
    end
  end
  
  # override to accept as secret word only alphabetic, space and punctuation
  # chars 
  def is_valid_secret_word? word
    replaced = word.gsub(/\p{Alpha}/,'')
                 .gsub(/\p{Space}/,'')
                 .gsub(/\p{Punct}/,'')
    if replaced.length == 0
      @secret_word = @secret_word_class.new word
      #checks is solved
      !@secret_word.is_solved?
    else
      puts "Secret word/phrase contains only alphabetic, space and punctuation, not " + replaced
    end
  end

end
  
class ExtendedSecretWord < SecretWord
  
  # override initialize to hide only alpha characters
  def initialize word
    self.word = word
    # Regex /\p{Alpha}/ Alphabetic character
    self.pattern = word.gsub(/\p{Alpha}/,'-')
  end

  # valid guess is 1 char long and alpha
  def valid_guess? guess
    guess.length == 1 and /\p{Alpha}/.match(guess)
  end

  # override to ignore case
  def guess_letter! letter
    # make lowercase copies of word and letter for comparison
    copy = self.word.downcase
    l = letter.downcase
    found = copy.index(l)
    if found
      start = 0
      # index begins searching at position start
      while ix = copy.index(l, start)
        #updates pattern with word letters at index found
        self.pattern[ix] = self.word[ix]
        #increments start to keep searching for same letter
        start = ix + 1
      end
    end
    found #produce found bool if letter inside word 
  end

end

## Change to `false` to run the original game
=begin
if false
  ExtendedGuessTheWordGame.new(ExtendedSecretWord).play
else
  GuessTheWordGame.new(SecretWord).play
end
=end


if ARGV.count == 0
  ExtendedGuessTheWordGame.new(ExtendedSecretWord).play
elsif ARGV.count != 1
  puts "usage: guessword.rb [enhanced | original]"
elsif ARGV[0] == "enhanced"
  ExtendedGuessTheWordGame.new(ExtendedSecretWord).play
elsif ARGV[0] == "original"
  GuessTheWordGame.new(SecretWord).play
else
  puts "usage: guessword.rb [enhanced | original]"
end
