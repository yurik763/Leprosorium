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
	#выбираем список постов из БД

	@results = @db.execute 'select * from Posts order by id desc'
	erb :index			
end

get '/new' do
  erb :new
end

post '/new' do
  @content = params[:content]

  if @content.length <= 0
  		@error = 'Введите текст поста'
  		return erb :new
  end

  #сохранение данных в БД
  @db.execute 'insert into Posts (content, ceated_date) values (?,datetime())', [@content]

  #перенаправление на главную страницу
  redirect to('/')
end


#вывод информации о посте
get '/details/:post_id' do
	post_id = params[:post_id]

	results = @db.execute 'select * from Posts where id = ?', [post_id]  #выбираются посты с id страницы
	@row = results[0]

	erb :details
end

