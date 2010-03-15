var requestPollEnabled = true;

function startPolling(){
  new PeriodicalExecuter(checkForRequests, 30);
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

function processRequests(data){
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
    showSupportRequested(data.request_id);
  }
  else
  {
    if(jQuery.fn.activebar && ($('help_link') && $('help_link').visible()) || $('help_link') == null)
      jQuery.fn.activebar.hide();
  }
}

function showSupportRequested(id){
  requestPollEnabled = false;
  
  if($('help_link') != null) $('help_link').hide();

  var text = "Help is on the way. <span style='float:right;'> Click here to cancel your request:</span>";

  var closeCallback = function(){
    jQuery.ajax({
      type: "PUT",
      url: '/support_requests/' + id,
      dataType: "script",
      data: {authenticity_token: encodeURIComponent(AUTH_TOKEN)}
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

function startStatusPolling(){
  new PeriodicalExecuter(checkForStatusRequests, 15);
}

function checkForStatusRequests(executer){ 
  jQuery.get('/status',null,null,"script"); 
}