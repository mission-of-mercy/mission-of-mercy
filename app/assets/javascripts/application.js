//= require jquery
//= require jquery_ujs
//= require_self
//= require_tree .

// Setup the MoM Namespace
var MoM = MoM ? MoM : new Object();

MoM.setupNamespace = function(namespace){
	if(MoM[namespace] == undefined)
		MoM[namespace] = {}
}

MoM.init = function(auth_token){
  MoM.AuthToken = auth_token;

  MoM.Support.startPolling();

  jQuery(function($) {
    $('img.help').click(function(e){
      helpBox = $(e.target).attr('data-help');

      $('#' + helpBox).slideToggle();
    });

    $('div.help-box img.close').click(function(e){
      $(e.target).parent().slideUp();
    });
  });
}

MoM.disableEnterKey = function(){
  $(document).observe('keypress', function(e) {
    if(e.keyCode == 13) e.stop();
  });
}

MoM.openInBackground = function(url){
   window.open(url); self.focus();
}

// Support
MoM.setupNamespace("Support");

// Toggle to disable support
MoM.Support.Enabled  = true;
MoM.Support.Interval = 20;

MoM.Support.startPolling = function (){
  new PeriodicalExecuter(MoM.Support.checkForRequests, MoM.Support.Interval);
}

MoM.Support.checkForRequests = function (executer){
  if(MoM.Support.Enabled){
    jQuery.getJSON('/active_support_requests.json',
      { authenticity_token: MoM.AuthToken},
      function(data){
        MoM.Support.processRequests(data);
      }
    );
  }
  else
   executer.stop();
}

MoM.Support.processRequests = function(data){
  if(data.requests.length > 0){

    var text    = "Help needed at " + data.requests;
    var options = {
			'icon': '/images/activebar/icon.png',
			'button': '/images/activebar/close.png',
			'highlight': 'InfoBackground',
			'border': 'InfoBackground'
		}

    if(jQuery.fn.activebar.container != null){
      jQuery('.content',jQuery.fn.activebar.container).html(text);
      jQuery.fn.activebar.updateBar(options);

      if(!jQuery.fn.activebar.container.is(':visible'))
        jQuery.fn.activebar.show();
    }
    else
    {
      jQuery('<div></div>').html(text).activebar(options);
  	}
  }
  else if(data.help_requested){
    MoM.Support.showSupportRequested(data.request_id);
  }
  else
  {
    if(jQuery.fn.activebar && ($('help_link') && $('help_link').visible()) || $('help_link') == null)
      jQuery.fn.activebar.hide();
  }
}

MoM.Support.showSupportRequested = function(id){
  MoM.Support.Enabled = false;

  if($('help_link') != null) $('help_link').hide();

  var text = "Help is on the way. <span style='float:right;'> Click here to cancel your request:</span>";

  var closeCallback = function(){
    jQuery.ajax({
      type: "PUT",
      url: '/support_requests/' + id,
      dataType: "script",
      data: {authenticity_token: MoM.AuthToken}
    });
  };


  var options = {
    'icon': '/images/activebar/icon.png',
    'button': '/images/activebar/close.png',
    'highlight': 'none repeat scroll 0 0 #d23234',
    'background': 'none repeat scroll 0 0 #d23234',
    'border': '#d23234',
    'fontColor': 'white',
    onClose: closeCallback
  }

  if(jQuery.fn.activebar.container != null){
    jQuery('.content',jQuery.fn.activebar.container).html(text);
    jQuery.fn.activebar.updateBar(options);

    if(!jQuery.fn.activebar.container.is(':visible'))
      jQuery.fn.activebar.show();
  }
  else
  {
    jQuery('<div></div>').html(text).activebar(options);
  }
}

MoM.Support.startStatusPolling = function(){
  new PeriodicalExecuter(MoM.Support.checkForStatusRequests, 15);
}

MoM.Support.checkForStatusRequests = function (executer){
  jQuery.ajax({
    url: '/status',
    timeout: 2000,
    dataType: "script",
    error: function(){
      $(document.body).addClassName('red')
      jQuery('#requests').html("<h1>Error connecting to server</h1>");
    }
  });
}
