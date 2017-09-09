class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :word, :guesses, :wrong_guesses
  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
    
  end
  
  def guess(letter)
    if repeat_or_invalid?(letter)
      return false
    end
    letter = letter.downcase
    if @word.include? letter
      if ! @guesses.include? letter
        @guesses << letter
        @guesses = @guesses.chars.sort.join
      end
    else
      if !@wrong_guesses.include? letter
        @wrong_guesses << letter
        @wrong_guesses = @wrong_guesses.chars.sort.join
      end
    end
    return true
  end
  
  def repeat_or_invalid?(letter)
    if letter == '' or letter =~ /[^a-z]/i or letter == nil
      raise ArgumentError.new("Invalid input.")
    end
    letter = letter.downcase
    if @guesses.include? letter or @wrong_guesses.include? letter
      return true
    end
    return false
  end
  
  def word_with_guesses
    r_string = ''
    @word.each_char { |c|
      if @guesses.include? c
        r_string << c
      else
        r_string << '-'
      end
    }
    return r_string
  end
  
  def check_win_or_lose
    if word_with_guesses() == @word
      return :win
    end
    if @wrong_guesses.length >= 7
      return :lose
    end
    return :play
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
