// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var Tstrni = new function() {
  
  this.clearAllTimeouts = function(){
    if (typeof Tstrni.clearAllTimeouts.last == 'undefined' ) {
      Tstrni.clearAllTimeouts.last = setTimeout("||void",0); // Opera || IE other browsers accept "" or "void"
    }
    var mx = setTimeout("||void",0);
    for(var i=Tstrni.clearAllTimeouts.last;i<=mx;i++){
      clearTimeout(i);
    }
    Tstrni.clearAllTimeouts.last = i;
  }
  
}