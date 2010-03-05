var requestPollEnabled = true;

function startPolling(){
  new PeriodicalExecuter(checkForRequests, 3);
}

function checkForRequests(executer){
  if(requestPollEnabled){
    new jQuery.getJSON('/active_support_requests.json', {authenticity_token: encodeURIComponent(AUTH_TOKEN)}, function(data){
      processRequests(data);
    }); 
  }
  else
   executer.stop();
}

function processRequests(requests){
  if(requests.length > 0){
    
    var text    = "Help needed at " + requests;
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
  else
  {
    if(jQuery.fn.activebar && ($('help_link') && $('help_link').visible()) || $('help_link') == null)
      jQuery.fn.activebar.hide();
  }
}