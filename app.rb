require 'sinatra'
require 'sinatra/reloader' if development?

enable :sessions

get '/' do

  erb :index, layout: :main

end
