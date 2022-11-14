require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ("a".."z").to_a.sample }
    @letters_array = @letters.map { |letter| [letter, get_letter_score(letter)] }
  end

  def score
    @word = params[:word]
    @grid = params[:grid].chars
  
    if check_word(@word.downcase)
      if check_letters(@word, @grid) == false
        @output = { score: 0, message: "Not in the grid" }
      else
        sum = @word.chars.reduce(0) { |sum, item| sum += get_letter_score(item) }
        score = @word.size + sum
        @output = { score: score, message: "Well done for \"#{@word.upcase}\"" }
      end
    else
      @output = { score: 0, message: "Not an English word" }
    end
  end

  private

  def get_letter_score(letter)
    letter = letter.upcase.to_sym
    points = {
      A: 1, B: 3, C: 3, D: 2, E: 1, F: 4, G: 2, H: 4, I: 1, J: 8, K: 10, L: 1, M: 2,
      N: 1, O: 1, P: 3, Q: 8, R: 1, S: 1, T: 1, U: 1, V: 4, W: 10, X: 10, Y: 10, Z: 10
    }
    points[letter]
  end

  def check_letters(word, grid)
    grid = grid.map { |item| item.downcase }
    word.downcase.chars.each do |char|
      if grid.include?(char)
        grid.delete_at(grid.index(char))
      else
        return false
      end
    end
  end

  def check_word(word)
    JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{word}").read)["found"]
  end

end
