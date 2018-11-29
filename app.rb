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

  erb :guess, layout: :main, :locals => {:guesses_remaining => guesses_remaining, :revealed_letters => revealed_letters,
                                         :all_guesses => all_guesses, :solution => solution}
end

get '/load_game' do

  #@@game = Game.new("load")

end

post '/guess' do

  guess = params["guess"].downcase
  @@game.play(guess)
  guesses_remaining = @@game.guesses_remaining
  revealed_letters = @@game.revealed_letters.join(' ')
  all_guesses = @@game.guesses.join(',')
  solution = @@game.random_word.downcase

  if @@game.game_over?
    redirect '/win' if @@game.revealed_letters.join('') == solution
    redirect '/lose' if guesses_remaining <= 0
  end

  erb :guess, layout: :main, :locals => {:guesses_remaining => guesses_remaining, :revealed_letters => revealed_letters,
    :all_guesses => all_guesses, :solution => solution}

end

get '/win' do

  solution = @@game.random_word
  erb :win, layout: :main, :locals => {:solution => solution}

end

get '/lose' do

  solution = @@game.random_word
  erb :lose, layout: :main, :locals => {:solution => solution}

end
