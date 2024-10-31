$(document).on('turbolinks:load', function(){
  $('.rating').on('ajax:success', function(e) {
    let vote = e.detail[0];

    $(`#likes-${vote.votable_id}`).text(vote.likes);
    $(`#rating-${vote.votable_id}`).text(vote.rating);
    $(`#dislikes-${vote.votable_id}`).text(vote.dislikes);
  }).on('ajax:error', function(event) {
    const [data] = event.detail;
    $('.vote-errors').text(data.error);
    console.error(data.error);
  });
});
