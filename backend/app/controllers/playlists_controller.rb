class PlaylistsController < ApplicationController
Dotenv.load

  def index
    @user = User.find(params[:user_id])
    @playlists = @user.playlists
    render json: {playlist: @playlists, user: @user}
  end

  # def new
  #   client=SoundCloud.new({
  #     :client_id => ENV['client_id'],
  #     :client_secret => ENV['client_secret'],
  #     :username => ENV['username'],
  #     :password => ENV['password']
  #     })
  #     @songs = client.get('/tracks', :q => params[:search], :limit => 10)

  #     # render json: @songs
  #     # @songs.each do |song|
  #       # p song.uri
  #       # p song.stream_url
  #       # p song.id
  #       # p "*" * 80
  #     # end

  # end
  def edit
      @playlist_id = params[:id]
      @user_id = params[:user_id]
      @user = User.find(params[:user_id])
      @playlist = Playlist.find(params[:id]).songs
      p "*" * 100
      render :json => {user: @user, playlist: @playlist}
  end

  ###test code not implemented yet


  def create
  # p params[:track_id]
  # p "*" * 80
    # p params
    # {"id"=>"3", "name"=>"dsdsdsa", "genre"=>"qwqwqwqwq", "user_id"=>"3"}
    @user = User.find(params['user_id'])
    @playlist = @user.playlists.create(name: params["name"],
      genre: params["genre"])
    render json: @playlist
    # @playlist = Playlist.create(name: params[:playlist_name], user_id:params[:user_id])
    # @playlist = @playlist.songs
    # @playlist = Playlist.all

    # @playlist = Playlist.create(name: params[:name], genre: params[:genre], user_id:params[:user_id])

    # p @playlist
    #   playlist = @user.playlists.create(name: params[:name], genre: parmas[:genre], user_id: params[:user_id])
    # p "*" * 80
    # p @playlist

    ##ACTUAL playlist would exist already from the user instances
  ###@song = @user.playlists.find(1).songs.create!(track_id: params[:track_id].to_i, title: params[:title])
  # render json: {playlist: @playlists, user: @user}



   # @song = Song.new(track_id: params[:track_id].to_i)
   # render json: @playlist
   # redirect_to
   # render json: @song
  end

  def show
    # p params
    # @playlist=Playlist.find(params[:id])
    @user = User.find(params[:user_id])
    @playlist = Playlist.find(params[:id])
    # @playlist_name = params[:name]

    # @playlist = @user.playlist.find(params[:id])
    # @playlist = @user.playlists.   where playlist(user_id = @user.id)
    # @user=User.find(1)
    # @songs = @user.playlists.find(1).songs.each do |x|
           # x.
    render json: {user: @user, playlist: @playlist }

  end
  #   # tracks will take song id params to populate array used make a new playlist
  #   # ###create an array of track_id's BEFORE creating playlist
  #   #     tracks = [21778201, 22448500, 21922889].map {|id| {:id => id}}
  #   #
  ##test code end
  def play
    userid = params["user_id"].to_i
    play = params["id"].to_i
    user = User.find(userid)
    list = user.playlists.find(play)
    songs = list.songs

    render json: songs
  end

end


  # var soundArray=songs
  #     SC.stream("http://api.soundcloud.com/tracks/" + songs[Math.random()*songs.length].soundcloud_id, {onfinish:
  #             function(sound){
  #               var index = soundArray.indexOf(sound);
  #               if (soundArray[index + 1] !== undefined) {
  #                     chain(soundArray[index + 1]);
  #               }
  #             }} )