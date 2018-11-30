require 'sinatra'
require 'sinatra/reloader' if development?
require_relative './lib/hangman.rb'

enable :sessions

get '/' do
  erb :index, layout: :main
end

get '/game' do

  @@game = Game.new("new")
  guesses_remaining = @@game.guesses_remaining
  revealed_letters = @@game.revealed_letters.join(' ')
  all_guesses = @@game.guesses.join(',')
  solution = @@game.random_word
  image_key = @@game.guesses_remaining.to_s
  hide_link = "hidden"

  erb :guess, layout: :main, :locals => {:guesses_remaining => guesses_remaining, :revealed_letters => revealed_letters,
                                         :all_guesses => all_guesses, :solution => solution, :image_key => image_key, :hide_link => hide_link}
end

post '/guess' do

  guess = params["guess"].downcase
  @@game.play(guess)
  guesses_remaining = @@game.guesses_remaining
  revealed_letters = @@game.revealed_letters.join(' ')
  all_guesses = @@game.guesses.join(',')
  solution = @@game.random_word.downcase
  image_key = @@game.guesses_remaining.to_s

  if @@game.game_over?
    redirect '/win' if @@game.revealed_letters.join('') == solution
    redirect '/lose' if guesses_remaining <= 0
  end

  erb :guess, layout: :main, :locals => {:guesses_remaining => guesses_remaining, :revealed_letters => revealed_letters,
    :all_guesses => all_guesses, :solution => solution, :image_key => image_key}

end

get '/win' do

  solution = @@game.random_word
  image_key = "win"
  erb :win, layout: :main, :locals => {:solution => solution, :image_key => image_key}

end

get '/lose' do

  solution = @@game.random_word
  image_key = "0"
  erb :lose, layout: :main, :locals => {:solution => solution, :image_key => image_key}

end
