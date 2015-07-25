class PlaylistsController < ApplicationController
Dotenv.load

  def index
    @user = User.find(params[:user_id])
    @playlists = @user.playlists
    render json: {playlist: @playlists, user: @user}
  end

  def edit
      @playlist_id = params[:id]
      @user_id = params[:user_id]
      @user = User.find(params[:user_id])
      @playlist = Playlist.find(params[:id]).songs
      p "*" * 100
      render :json => {user: @user, playlist: @playlist}
  end

  def create
    @user = User.find(params['user_id'])
    @playlist = @user.playlists.create(name: params["name"],
      genre: params["genre"])
    render json: @playlist
  end

  def show
    @user = User.find(params[:user_id])
    @playlist = Playlist.find(params[:id])
    render json: {user: @user, playlist: @playlist }
  end

  def play
    userid = params["user_id"].to_i
    play = params["id"].to_i
    user = User.find(userid)
    list = user.playlists.find(play)
    songs = list.songs
    render json: songs
  end

end