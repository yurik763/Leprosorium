#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
end

#вызыается каждый раз при перезагрузке страницы любой страницы
before do
	#иницализация БД
	init_db
end

#configure вызывается каждый раз приконфигируции приложения:
#когда изменился код программы и перезагрузилась страница

configure do
	#инициализация БД
	init_db
	#создает таблицу
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts 
	(
	 		id INTEGER PRIMARY KEY AUTOINCREMENT, 
	 		ceated_date DATE, 
	 		content TEXT
	 )'
end

get '/' do
	erb "Hello!"			
end

get '/new' do
  erb :new
end

post '/new' do
  @content = params[:content]

  erb "You typed: #{@content}"
end