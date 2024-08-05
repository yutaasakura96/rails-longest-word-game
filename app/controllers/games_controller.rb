class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    @letters = ('A'..'Z').to_a.sample(10)
    session[:letters] = @letters # Store letters in session
    session[:start_time] = Time.now.to_f
  end

  def score
    @letters = session[:letters] # Retrieve letters from session
    @answer = params[:answer].upcase
    start_time = session[:start_time]
    end_time = Time.now.to_f
    word_count = @answer.length
    time_taken = (end_time - start_time).to_i
    score = word_count + time_taken

    # Validate if the answer can be built from the letters
    answer_letters = @answer.chars
    valid_word = answer_letters.all? { |letter| answer_letters.count(letter) <= @letters.count(letter) }

    if !valid_word
      @result = "Sorry but #{@answer} can't be built out of #{@letters.join(', ')}"
    else
      # Open the URL and read the response
      url = "https://dictionary.lewagon.com/#{@answer}"
      response = URI.open(url).read

      # Parse the JSON response
      data = JSON.parse(response)

      # Check if the word is valid
      real_word = data['found'] == true

      if real_word
        @result = "Congratulations #{@answer} is a valid English word!"
        @time_result = "Time Taken to answer: #{time_taken} seconds"
        @score_result = "Your Score: #{score} points!"
      else
        @result = "Sorry but #{@answer} does not seem to be a valid English word"
      end
    end
  end
end
