$(function() {
  var disableFieldset = function(target) {
    var $this = $(target),
      data = $this.data('disable'),
      targetGroup = data.group;

    if(data.disable) {
      jQuery('#' + targetGroup).attr('disabled', 'disabled');
    } else {
      jQuery('#' + targetGroup).attr('disabled', null);
    }
  }

  jQuery(':input[data-disable]').on('change', function(e) {
    disableFieldset(e.target);
  });

  jQuery(':input[data-disable]:checked').each(function(i, target) {
    disableFieldset(target);
  });
})
