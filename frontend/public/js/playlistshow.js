$(document).ready(function(){

  playlistSongs = []
  var bac = window.location.pathname
  var playlid = bac.match('/.*/(.*).*/')[1]
  var user_id = bac.match(/\/users\/(\d+)/)[1]
  $.ajax({
    url:"http://localhost:3000/users/"+user_id+ "/playlists/"+playlid+"/play",
    type:'GET',
    data:$(this).serialize(),
    async:false
  }).done(function(response){
    for(var i=0; i<response.length; i++){
      playlistSongs.push({
        "title":response[i].title,
        "song_url": response[i].song_url,
        "soundcloud_id": response[i].track_id.toString(),
        "artwork_url":response[i].artwork_url
      })
    }
  })

  showValue = function(newValue){
    document.getElementById("range").innerHTML=newValue;
  }

  Track = function (trackId){
    var currentTrack = "";

    SC.initialize({
      client_id: 'db17be73cc8a86e63b53a69839d67352'
    });

    SC.stream("http://api.soundcloud.com/tracks/" + trackId,{onfinish: function(){
      currentPlayingTrack.stop();
      currentTrack = rotation.nextTrack();
      currentPlayingTrack = new Track(currentTrack.soundcloud_id);
      currentPlayingTrack.play();
      $('.trackTitle').html(currentTrack.title);
    }
  }, function(sound){currentTrack = sound});

    this.volume = function(num){
      if (num >= 0 && num <= 100){

        currentTrack.setVolume(num)
      } else {
        currentTrack.setVolume(100)
      }
    }

    this.mute = function(){
      currentTrack.mute();
    }

    this.unmute = function(){
      currentTrack.unmute();
    }

    this.pause = function() {
      currentTrack.pause();
    };

    this.stop = function() {
      currentTrack.stop();
    };

    this.prevSong = function(){
      currentTrack.stop()
    }

    this.repeat = function(){
      currentTrack.pause()
      currentTrack.play({onfinish: function(){currentTrack.play()} })
    }

    this.play = function() {
      currentTrack.play({
        onfinish: function(){
          firebase()
          $('.trackTitle').html(currentTrack.title);
          currentTrack = rotation.nextTrack()
          currentPlayingTrack = new Track(currentTrack.soundcloud_id)
          currentPlayingTrack.play()
          $('.trackTitle').html(currentTrack.title)
        },
        onload: function() {
          if (this.readyState == 2) {
            // rotation.nextTrack()
            currentTrack = rotation.nextTrack()
            currentPlayingTrack = new Track(currentTrack.soundcloud_id)
            currentPlayingTrack.play()
            $('.trackTitle').html(currentTrack.title)
          }
        },
      });
    };

  } //Track end

  Rotation = function(tracks) {

    var currentTrack = tracks[0];
    var lastTrack = tracks[tracks.length-1]
    this.currentTrack = function () {
      $('.current_picture').attr('src', currentTrack.artwork_url)
      return currentTrack;
    };

    this.nextTrack = function () {
      var currentIndex = tracks.indexOf(currentTrack);
      var nextTrackIndex = currentIndex + 1;
      if (nextTrackIndex === $('.playlist').children().length){
        playlistlength = $('.playlist').children().length
        rotation = new Rotation(playlistSongs)
        currentTrack = rotation.currentTrack();
        currentPlayingTrack = new Track(currentTrack.soundcloud_id);
        currentPlayingTrack.play();
        $('.trackTitle').html(rotation.currentTrack().title);
        $('#pause').show();
        $('#play').hide();
      } else {
        console.log(nextTrackIndex)
        var nextTrackId = tracks[nextTrackIndex];
        console.log(nextTrackIndex)
        currentTrack = nextTrackId;
        return currentTrack
      }
    };

    this.lastTrack = function() {
      var currentIndex = tracks.indexOf(currentTrack);
      var nextTrackIndex = currentIndex - 1;
            console.log(nextTrackIndex)
            var nextTrackId = tracks[nextTrackIndex];
            currentTrack = nextTrackId;
            return currentTrack
        };
        //this.lastTrack still needs to be finished

  }; //Rotation end

  rotation = new Rotation(playlistSongs);
  currentTrack = rotation.currentTrack();
  currentPlayingTrack = new Track(currentTrack.soundcloud_id);

  $('#play').on('click', function(event){
    currentPlayingTrack.play();
    $('.trackTitle').html(rotation.currentTrack().title);
    $('#pause').show();
    $('#play').hide();
  });

  $('#pause').on('click', function(event){
    currentPlayingTrack.pause();
      $('.trackTitle').html(rotation.currentTrack().title);
      $('#pause').hide();
      $('#play').show();
    });

  $('#stop').on('click', function(event){
    currentPlayingTrack.stop();
    $('.trackTitle').html(rotation.currentTrack().title);
    $('#pause').hide();
    $('#play').show();
    });

  $('#next').on('click', function(event){
    currentPlayingTrack.stop();
      currentTrack = rotation.nextTrack();
      currentPlayingTrack = new Track(currentTrack.soundcloud_id);
      currentPlayingTrack.play();
      $('.trackTitle').html(rotation.currentTrack().title);
    });

  $('#prevsong').on('click', function(event){
    currentPlayingTrack.stop();
    currentTrack = rotation.lastTrack();
    currentPlayingTrack = new Track(currentTrack.soundcloud_id);
    currentPlayingTrack.play();
    $('.trackTitle').html(rotation.currentTrack().title);
    $('#pause').show();
    $('#play').hide();
  });

  $('#repeat').on('click', function(event){
    currentPlayingTrack.repeat();
    $('.trackTitle').html(rotation.currentTrack().title);
  });

  $('#volume').change(function(event){
    currentPlayingTrack.volume($('#range')[0].innerHTML)
    console.log($('#range')[0].innerHTML)
  })

})

function reload_js(src) {
  $('script[src="' + src + '"]').remove();
  $('<script>').attr('src', src).appendTo('head');
}

reload_js('/js/firebase.js');

var skipTrigger = new Firebase("https://backseatdj.firebaseIO.com/triggers/skipTrigger");

skipTrigger.on("value", function(snapshot) {
  if (snapshot.val() === true){
    $('#next').trigger('click')
    skipTrigger.set(false)
    reload_js('/js/firebase.js');
  }
})

var replayTrigger = new Firebase("https://backseatdj.firebaseIO.com/triggers/replayTrigger");

replayTrigger.on("value", function(snapshot) {
  if (snapshot.val() === true){
    $('#repeat').trigger('click')
    replayTrigger.set(false)
    reload_js('/js/firebase.js');
  }
})