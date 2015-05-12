class UsersController < ApplicationController
  Dotenv.load

  def index
    # p "*"*80
    # p username = params["username"]
    # p "*"*80
    # p pass = params["password"]
    # p "*"*80
    # p User.exists?(user_name: params["username"])
    # user =  User.where(user_name: params["username"]).first
    # p user.password
    # p user.password == params["password"]
    # p User.where(user_name: params["username"]).first.password = params["password"]

    if User.exists?(user_name: params["username"]) && User.where(user_name: params["username"]).first.password == params["password"]
    client = SoundCloud.new({
      :client_id => ENV['client_id'],
      :client_secret => ENV['client_secret'],
      :username => ENV['username'],
      :password => ENV['password'],
      :redirect_uri  => "http://localhost:3000/callback.html"
      # :redirect_uri => "google.com"

      })
    redirect_to client.authorize_url()

    else
      # redirect_to "https://soundcloud.com/captioncat/sad-trombone"
      redirect_to "https://www.youtube.com/watch?v=fmz-K2hLwSI"
    end





  end

  def auth
    client = SoundCloud.new({
      :client_id => ENV['client_id'],
      :client_secret => ENV['client_secret'],
      :username => ENV['username'],
      :password => ENV['password'],
      # :redirect_uri  => "http://localhost:3000/callback.html"
      # :redirect_uri => "/users"
      })
    code = params[:code]
    access_token = client.exchange_token(:code => code)
    # p access_token
    david = Soundcloud.new(:access_token => access_token.access_token)
    current_user = david.get('/me')
    # current_user = SoundCloud.new(:access_token => access_token).get('/me')
    # puts current_user.full_name
    # p access_token
    # call here to sound cloud with code to get his info as another params
    p "*" * 100
    p params
    p "*" * 100

   #NO RENDER after HTTParty?!?!?!??!?!
    # redirect_to "http://localhost:9393/users/1/playlists"
  end

  def callback
    # post to create session
    # manual sessions to rail api
  end

  def new
    # User.find(params[:id])
  end

  def create
    p "*" * 100
    p params
    p "*" * 100
    user = User.new(user_name: params["user_name"], password: params["password"])
    user.save
  end

end
