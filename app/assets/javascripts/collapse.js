$(function(){
  $('[data-toggle=collapse]').click(function(e) {
    e.preventDefault();
    $target = $($(e.target).data('target'));
    if($target.is(":hidden")) {
      $target.slideDown();
    } else {
      $target.slideUp();
    }
  });
});
