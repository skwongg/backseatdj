class UsersController < ApplicationController
  Dotenv.load

  def index
    client = SoundCloud.new({
      :client_id => ENV['client_id'],
      :client_secret => ENV['client_secret'],
      :username => ENV['username'],
      :password => ENV['password'],
      :redirect_uri  => "http://localhost:3000/callback.html"
      })
    redirect_to client.authorize_url()
  end

  def auth
    client = SoundCloud.new({
      :client_id => ENV['client_id'],
      :client_secret => ENV['client_secret'],
      :username => ENV['username'],
      :password => ENV['password']
      })
    code = params[:code]
    access_token = client.exchange_token(:code => code)
    david = Soundcloud.new(:access_token => access_token.access_token)
    current_user = david.get('/me')
    p "*" * 100
    p params
    p "*" * 100
    redirect_to "http://localhost:9393/users/redirect"
  end

  def callback
  end

  def session
    p params["user_name"]
    @user = User.where(user_name: params["user_name"]).first
    p @user
    render json: @user
  end

  def new
  end

  def create
    p "*" * 100
    p params
    p "*" * 100
    user = User.create(user_name: params["user_name"], password: params["password"])
    p user
    redirect_to "http://localhost:9393"
  end

end
