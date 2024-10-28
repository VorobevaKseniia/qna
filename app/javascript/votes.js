$(document).on('turbolinks:load', function(){
  $('.rating').on('ajax:success', function(e) {
    let votes = e.detail[0];

    $('#like-count').text(votes.likes);
    $('#dislike-count').text(votes.dislikes);
  })
});