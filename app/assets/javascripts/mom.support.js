// Support
MoM.setupNamespace("Support");

// Toggle to disable support
MoM.Support.Enabled  = true;
MoM.Support.Interval = 20;    // In seconds
MoM.Support.Timer    = null;

MoM.Support.init = function(startPolling){
  $('img.help').click(function(e){
    helpBox = $(e.target).attr('data-help');

    $('#' + helpBox).slideToggle();
  });

  $('div.help-box img.close').click(function(e){
    $(e.target).parent().slideUp();
  });

  if(startPolling == true) MoM.Support.startPolling();
}

MoM.Support.startPolling = function (){
  var interval = MoM.Support.Interval * 1000;
  MoM.Support.Timer = setInterval(MoM.Support.checkForRequests, interval);

  $('#help_link').click(function(){
    $('#help_loading').show();
    $(this).hide();
  });
}

MoM.Support.checkForRequests = function (){
  if(MoM.Support.Enabled){
    $.getJSON('/active_support_requests.json',
      function(data){
        MoM.Support.processRequests(data);
      }
    );
  }
  else
    clearInterval(MoM.Support.Timer);
}

MoM.Support.processRequests = function(data){
  if(data.requests.length > 0){

    var text    = "Help needed at " + data.requests;
    var options = {
			'icon': '/assets/activebar/icon.png',
			'button': '/assets/activebar/close.png',
			'highlight': 'InfoBackground',
			'border': 'InfoBackground'
		}

    if($.fn.activebar.container != null){
      $('.content',$.fn.activebar.container).html(text);
      $.fn.activebar.updateBar(options);

      if(!$.fn.activebar.container.is(':visible'))
        $.fn.activebar.show();
    }
    else
    {
      $('<div></div>').html(text).activebar(options);
  	}
  }
  else if(data.help_requested){
    MoM.Support.showSupportRequested(data.request_id);
  }
  else
  {
    if($('#activebar-container').is(":visible"))
      $.fn.activebar.hide();
  }
}

MoM.Support.showSupportRequested = function(id){
  MoM.Support.Enabled = false;

  if($('#help_link') != null) $('#help_link').hide();

  var text = "Help is on the way. <span style='float:right;'> Click here to cancel your request:</span>";

  var closeCallback = function(){
    $.ajax({
      type: "PUT",
      url: '/support_requests/' + id,
      dataType: "script"
    });
  };


  var options = {
    'icon': '/assets/activebar/icon.png',
    'button': '/assets/activebar/close.png',
    'highlight': 'none repeat scroll 0 0 #d23234',
    'background': 'none repeat scroll 0 0 #d23234',
    'border': '#d23234',
    'fontColor': 'white',
    onClose: closeCallback
  }

  if($.fn.activebar.container != null){
    $('.content',$.fn.activebar.container).html(text);
    $.fn.activebar.updateBar(options);

    if(!$.fn.activebar.container.is(':visible'))
      $.fn.activebar.show();
  }
  else
  {
    $('<div></div>').html(text).activebar(options);
  }
}