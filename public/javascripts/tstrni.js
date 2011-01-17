var Tstrni = new function(){
  
  /*** to show and hide the promo bar at the top of the page ***/
  // this.promo = function() {
  //   this.show = function() {
  //     $('#promo').slideDown(800, 'easeOutElastic');
  //   }
  //   this.hide = function(){
  //     $('#promo').slideUp();
  //     $('#top-band').removeClass('with_promo');
  //     $.post('/hide_promo');
  //   }
  // }
  
  this.show_promo = function() {
    $('#promo').slideDown(800, 'easeOutElastic');
  }
  
  this.hide_promo = function(){
    $('#promo').slideUp();
    $('#top-band').removeClass('with_promo');
    $.post('/hide_promo');
  }
  
  this.pausePoints;
  
  /*** to control the youtube player ***/
  this.play = function(playerId){
    if(playerId){
      document.getElementById(playerId).playVideo();
    }
  }
  
  this.pause = function(playerId){
    if(playerId){
      document.getElementById(playerId).pauseVideo();
    }
  }
  
  this.stop = function(playerId){
    if(playerId){
      document.getElementById(playerId).stopVideo();
    }
  }
  
  this.playAndPause = function(playerId){
    Tstrni.play(playerId);
    //alert(Tstrni.pausePointsForTest.testId);
    
    // {'testId' => id, 'pausePoints' => [{4 => 1}, {8 => 2}, {12 => 3}]}
    stopTime = Tstrni.pausePointsForTest.pausePoints[0]
    alert("typeof stopTime: " + typeof stopTime);
    alert("stopTime: " + stopTime);
    if(playerId){
      if(document.getElementById(playerId).getCurrentTime() <= stopTime) {
        // every second, call pauseAt, which will check the time and pause if appropriate
        pauseIntervalId = setInterval("Tstrni.pauseAt('" + playerId + "', " + stopTime + ")", 1000);
      }
    }
    return pauseIntervalId;
  }
  
  // is it possible to pass in the pauseIntervalId to be cleared? not good that it's an externality
  this.pauseAt = function(playerId, stopAtSecond){
    player = document.getElementById(playerId)
    currentTime = player.getCurrentTime()
    if(player.getPlayerState() == 1) {
      if(currentTime >= stopAtSecond) {
        Tstrni.pause(playerId);
        clearInterval ( pauseIntervalId );
      }
      
      // if there's another pause point farther on, set it
      // pausePointsForTest needs to check test id, in case there's more than one floating around
      // also needs to get cleaned up if they stop the test
      if(Tstrni.pausePointsForTest){
        
      }
    }
  }
  
  this.seekTo = function(id, seconds){
    if(id){
      document.getElementById(id).seekTo(seconds, true);
    }
  }
  
  // THIS IS IT! Use this to stop the video at a predetermined point and ask a question. Logic is:
  // - when creating question, tie it to a point in the video (in seconds)
  // - before starting video, see if it has any point-in-time questions
  // - if so, start a watcher for each at the same time the video starts.
  // - when a watcher sees that the current time in the video matches a stop point:
  //   + call 'pauseAt'
  //   + trigger js to display question
  
  // for multiple question in the test:
  // - put an array of stopPoints in the Tstrni object. 
  // - set the first one
  // - when it clears, check if there's one after that, and if so, set it
  // - repeat until there are no more
  
  //   + upon completion of question, pause briefly (2 seconds?), and restart the video
  
  
  // call like this:
  // pauseIntervalId = setInterval ( "Tstrni.pauseAt('ytplayer', 4)", 1000 );
  
  
  /*** to follow and unfollow people ***/
  this.follow = function(followerId, obj, followeeId){
    $.get('/people/'+followerId+'/follow/'+obj+'/'+followeeId, function(data) {
      $('#follow').html(data);
    });
  }
  
  this.unfollow = function(followerId, obj, followeeId){
    $.get('/people/'+followerId+'/unfollow/'+obj+'/'+followeeId, function(data) {
      $('#follow').html(data);
    });
  }
  
  
  /*** to open the signup and login lightboxes ***/
  
  this.viewSignup = function(){
    //$('#return_to').val(url);
    $('#signup').lightbox_me({
      centered: true,
      overlaySpeed:200,
      lightboxSpeed:200,
      overlayDisappearSpeed:200,
      onLoad: function() { 
        $('#user_username').focus();
      }
    });
    return false;
  }
  
  this.viewLogin = function(){
    $('#signup').lightbox_me({
      centered: true,
      overlaySpeed:200,
      lightboxSpeed:200,
      overlayDisappearSpeed:200,
      onLoad: function() { 
        $('#user_username').focus();
        $('.login').toggle();
      }
    });
  }
  
  this.clear_state = function() {
    $.bbq.removeState();
  }
  
}