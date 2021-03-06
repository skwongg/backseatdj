# require 'httparty'
# require 'firebase'

get '/users/:user_id/playlists' do
  @user = params[:user_id]
  response = HTTParty.get("http://localhost:3000/users/#{params[:user_id]}/playlists").parsed_response
  @playlists = response["playlist"]
  @current_user = response["user"]
  erb :"playlists/index"
end

post '/users/:user_id/playlists' do
  response = HTTParty.post("http://localhost:3000/users/#{params[:user_id]}/playlists", body: {name: params[:name], genre: params[:genre]}).parsed_response["id"]
  redirect "/users/#{params[:user_id]}/playlists/#{response.to_s}"
end

get '/users/:user_id/playlists/:id' do
  @playlist_id = params[:id]
  @user =  params[:user_id]
  response = HTTParty.get("http://localhost:3000/users/#{params[:user_id]}/playlists").parsed_response
  @playlist = response["playlist"]
  erb :"playlists/show"
end

get '/users/:user_id/playlists/:id/play' do
  userid = params[:user_id].to_i
  listid = params[:id].to_i
  playlist_response = HTTParty.get("http://localhost:3000/users/#{userid}/playlists/#{listid}/play").parsed_response
  base_uri = 'https://backseatdj.firebaseio.com/'
  @rep = playlist_response
  firebase = Firebase::Client.new(base_uri)
  response = firebase.set("playlist", { :playlistId => listid, :userId => userid })
  erb :"playlists/play"
end


