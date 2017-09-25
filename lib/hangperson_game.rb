class HangpersonGame
  
  attr_accessor :word, :guesses, :wrong_guesses
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end
  
  def guess(letter)
    raise ArgumentError if letter == ""
    raise ArgumentError if letter !~ %r{\w}
    letter.downcase!
      if  @word.include?(letter) 
        !@guesses.include?(letter) ? @guesses << letter : false

      else
        @wrong_guesses.include?(letter) ? false : wrong_guesses << letter 
      end
  end
  
  def word_with_guesses(word=@word, guesses=@guesses)
    guesses_list = @guesses.to_s
    guesses_rx = /[^ #{guesses_list}]/
    @masked = @word.gsub(guesses_rx, "-")
    @masked.scan(/[a-z\-]/).join
  end

  def check_win_or_lose
    if ( @wrong_guesses.length ==  7 ) 
      :lose
    elsif ( ! self.word_with_guesses.include?("-") )
      :win
    else
      :play
    end
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
