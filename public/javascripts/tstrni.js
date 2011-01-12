// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var Tstrni = new function(){
  
  /*** to control the youtube player ***/
  this.play = function(id){
    if(id){
      player = document.getElementById(id);
      player.playVideo();
      
      var stopTime = 4;
      
      if(player.getCurrentTime() <= stopTime) {
        pauseIntervalId = setInterval ( "Tstrni.pauseAt('" + id + "', " + stopTime + ")", 1000 );
      }
    }
  }
  this.pause = function(id){
    if(id){
      document.getElementById(id).pauseVideo();
    }
  }
  this.stop = function(id){
    if(id){
      document.getElementById(id).stopVideo();
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
  
  this.pauseAt = function(id, stopAtSecond){
    player = document.getElementById(id)
    if(player.getPlayerState() == 1) {
      if(player.getCurrentTime() >= stopAtSecond) {
        Tstrni.pause(id);
        clearInterval ( pauseIntervalId );
      }
    }
  }
  
  this.seekTo = function(id, seconds){
    if(id){
      document.getElementById(id).seekTo(seconds, true);
    }
  }
  
  /*** to show and hide the promo bar at the top of the page ***/
  this.promo = function() {
    this.show = function() {
      $('#promo').slideDown(800, 'easeOutElastic');
    }
    this.hide = function(){
      $('#promo').slideUp();
      $('#top-band').removeClass('with_promo');
      $.post('/hide_promo');
    }
  }
  
  
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