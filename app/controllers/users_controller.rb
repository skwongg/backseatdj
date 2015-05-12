class UsersController < ApplicationController
  Dotenv.load

  def index
    p "*"*80
    p username = params["username"]
    p "*"*80
    p pass = params["password"]
    p "*"*80
    p User.exists?(user_name: params["username"])
    user =  User.where(user_name: params["username"]).first
    p user.password
    p user.password == params["password"]


    if User.exists?(user_name: params["username"])
    else


    # if User.exists?(user_name: params["username"])
    #   if User.where(user_name: params["username"]).first.password == params["password"]
    #   end
    # end

    # if User.where(user_name: username).first
    #   p "yo"
    # else
    #   p "fuck"
    #   redirect_to "http://localhost:9393"
    # end

    # login = User.where(user_name: params["username"]).first
    # p login
    # p "login"
    # # p login.password
    # if pass == login.password_hash
    #   p "works"
    # else
    #   p "fail"
    # end

    # user_login = params["username"]
    # session[:user_id] = @current_user.id
    # p "*"*80
    # if User.where(username: user_login).exists?



    client = SoundCloud.new({
      :client_id => ENV['client_id'],
      :client_secret => ENV['client_secret'],
      :username => ENV['username'],
      :password => ENV['password'],
      :redirect_uri  => "http://localhost:3000/callback.html"
      # :redirect_uri => "google.com"

      })
    redirect_to client.authorize_url()
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
  end

  def new
    # User.find(params[:id])
  end

  def create
    p "*" * 100
    p params
    p "*" * 100
    @user = User.create(user_name: params["user_name"], password: params["password"])

  end

end
