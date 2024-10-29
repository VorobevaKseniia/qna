$(document).on('turbolinks:load', function(){
  $('.rating').on('ajax:success', function(e) {
    let vote = e.detail[0];
    console.log(e.detail[0])
    console.log(vote.votable_id)
    console.log(vote.likes)

    $(`#likes-${vote.votable_id}`).text(vote.likes);
    $(`#rating-${vote.votable_id}`).text(vote.rating);
    $(`#dislikes-${vote.votable_id}`).text(vote.dislikes);
  });
});