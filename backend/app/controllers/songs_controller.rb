class SongsController < ApplicationController
Dotenv.load

  def index
    client=SoundCloud.new({
      :client_id => ENV['client_id'],
      :client_secret => ENV['client_secret'],
      :username => ENV['username'],
      :password => ENV['password']
      })
      @songs = client.get('/tracks', :q => params[:search], :limit => 10)
      p @songs
      render json: @songs
  end

  def create
    p params
    p "*" * 100
    @user = User.find(params[:user_id])
    @song = Song.create!(track_id: params[:track_id],
                          title: params[:title],
                          playlist_id: params[:playlist_id],
                          artwork_url: params[:artwork_url],
                          song_url: params[:song_url])
    render json: @song
  end

  def show
    p params
  end

  def upskip
    song = Song.where(id: params[:id]).first
    song.skip += 1
    song.save
    p song.skip
    render json: {id: song.id, skip: song.skip}
  end

  def downskip
    song = Song.where(id: params[:id]).first
    song.skip -= 1
    song.save
    render json: {id: song.id, skip: song.skip}
  end

  def upreplay
    song = Song.where(id: params[:id]).first
    song.replay += 1
    song.save
    render json: {id: song.id, skip: song.replay}
  end

  def downreplay
    song = Song.where(id: params[:id]).first
    song.replay -= 1
    song.save
    render json: {id: song.id, skip: song.replay}
  end

end
