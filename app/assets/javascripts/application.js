//= require jquery
//= require jquery_ujs
//= require_tree ../../../vendor/assets/javascripts
//= require_self
//= require_tree .

$.facebox.settings.closeImage   = '/assets/facebox/closelabel.png';
$.facebox.settings.loadingImage = '/assets/loading.gif';

// Setup the MoM Namespace
var MoM = MoM ? MoM : new Object();

MoM.setupNamespace = function(namespace){
	if(MoM[namespace] == undefined)
		MoM[namespace] = {}
}

MoM.init = function(){
  MoM.Support.init(true);
}

MoM.disableEnterKey = function(form){
  $(form).keypress(function(e) {
    if(e.keyCode == 13) e.preventDefault();
  });
}

MoM.openInBackground = function(url){
   window.open(url); self.focus();
}