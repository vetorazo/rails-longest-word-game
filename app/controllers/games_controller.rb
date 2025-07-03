class GamesController < ApplicationController
  def new
    letters = ('a'..'z').to_a
    @letters = Array.new(10) { letters.sample }
  end

  def score
    # The word can't be built out of the original grid
    @word = params[:word].downcase
    @letters = params[:letters].downcase
    @score = 0
    @message = ''

    # if word cannot be built out of the original grid
    if @word.chars.any? { |letter| @word.count(letter) > @letters.count(letter) }
      @message = "Sorry but #{@word.upcase} can't be built out of #{@letters.gsub(/[^a-zA-Z]/, '').upcase.chars.join(', ')}"
    elsif !valid_word?(@word)
      @message = "Sorry but #{@word.upcase} does not seem to be a valid English word..."
    else
      @message = "Congratulations! #{@word.upcase} is a valid English word!"
    end
  end

  private

  def valid_word?(word)
    require 'net/http'
    require 'json'
    url = URI("https://dictionary.lewagon.com/#{word}")
    response = Net::HTTP.get(url)
    json = JSON.parse(response)
    json['found']
  end
end
