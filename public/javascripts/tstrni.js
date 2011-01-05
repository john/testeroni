// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var Tstrni = new function(){
  
  this.promo = new function() {
    this.show = function() {
      $('#promo').slideDown(800, 'easeOutElastic');
    }
    this.hide = function(){
      $('#promo').slideUp();
      $('#top-band').removeClass('with_promo');
      $.post('/hide_promo');
    }
  }
  
  //this.viewSignup = function(url){
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
  
  // this.clearAllTimeouts = function(){
  //   if (typeof Tstrni.clearAllTimeouts.last == 'undefined' ) {
  //     Tstrni.clearAllTimeouts.last = setTimeout("||void",0); // Opera || IE other browsers accept "" or "void"
  //   }
  //   var mx = setTimeout("||void",0);
  //   for(var i=Tstrni.clearAllTimeouts.last;i<=mx;i++){
  //     clearTimeout(i);
  //   }
  //   Tstrni.clearAllTimeouts.last = i;
  // }
  
  this.clear_state = function() {
    $.bbq.removeState();
  }
  
}