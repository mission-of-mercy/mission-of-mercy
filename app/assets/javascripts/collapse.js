$(function(){
  $('[data-toggle=collapse]').click(function(e) {
    e.preventDefault();
    $chart = $($(e.target).data('target'));
    if($chart.is(":hidden")) {
      $chart.slideDown();
    } else {
      $chart.slideUp();
    }
  });
});
