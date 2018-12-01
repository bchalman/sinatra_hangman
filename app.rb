require 'sinatra'
require 'sinatra/reloader' if development?
require_relative './lib/hangman.rb'

enable :sessions

get '/' do
  erb :index, layout: :main
end

get '/game' do

  session['game'] = Game.new("new")
  guesses_remaining = session['game'].guesses_remaining
  revealed_letters = session['game'].revealed_letters.join(' ')
  all_guesses = session['game'].guesses.join(',')
  solution = session['game'].random_word
  image_key = session['game'].guesses_remaining.to_s
  hide_link = "hidden"

  erb :guess, layout: :main, :locals => {:guesses_remaining => guesses_remaining, :revealed_letters => revealed_letters,
                                         :all_guesses => all_guesses, :solution => solution, :image_key => image_key, :hide_link => hide_link}
end

post '/guess' do

  guess = params["guess"].downcase
  session['game'].play(guess)
  guesses_remaining = session['game'].guesses_remaining
  revealed_letters = session['game'].revealed_letters.join(' ')
  all_guesses = session['game'].guesses.join(',')
  solution = session['game'].random_word.downcase
  image_key = session['game'].guesses_remaining.to_s

  if session['game'].game_over?
    redirect '/win' if session['game'].revealed_letters.join('') == solution
    redirect '/lose' if guesses_remaining <= 0
  end

  erb :guess, layout: :main, :locals => {:guesses_remaining => guesses_remaining, :revealed_letters => revealed_letters,
    :all_guesses => all_guesses, :solution => solution, :image_key => image_key}

end

get '/win' do

  solution = session['game'].random_word
  image_key = "win"
  erb :win, layout: :main, :locals => {:solution => solution, :image_key => image_key}

end

get '/lose' do

  solution = session['game'].random_word
  image_key = "0"
  erb :lose, layout: :main, :locals => {:solution => solution, :image_key => image_key}

end
